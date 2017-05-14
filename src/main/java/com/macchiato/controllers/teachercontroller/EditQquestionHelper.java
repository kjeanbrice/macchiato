package com.macchiato.controllers.teachercontroller;
import com.google.appengine.api.datastore.*;
import com.google.appengine.api.users.User;
import com.macchiato.beans.QuestionBean;
import com.macchiato.utility.GenUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Created by Xiangbin on 5/12/2017.
 * this method will help teacher question to load the problem and solution from the database
 */
@Controller
public class EditQquestionHelper {
    @RequestMapping(value="/findQuestion.htm", method = RequestMethod.GET)
    //this method will help teacher question to load the problem and solution from the database
    public void editCourse(HttpServletRequest request, HttpServletResponse response) throws IOException {
        PrintWriter out = response.getWriter();
        User active_user = GenUtils.getActiveUser();
        String instructor_email =active_user.getEmail();
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        if (instructor_email == null ) {
            System.out.println("active_user is null");
        }
        else{
            String QuestionId=request.getParameter("questionKey");
            //System.out.println("---------"+QuestionId);
            Query.Filter questionkey_filter = new Query.FilterPredicate("questionKey", Query.FilterOperator.EQUAL,QuestionId );
            Query q = new Query("Question").setFilter(questionkey_filter);
            PreparedQuery pq = datastore.prepare(q);
            int numberOfClass = pq.asList(FetchOptions.Builder.withDefaults()).size();
            //System.out.println("This is the number  of question that i found"+numberOfClass);
            if(numberOfClass!=1){
                System.out.println("Question code error");
            }
            else{
                for (Entity result : pq.asIterable()) {
                    String problem = (String) result.getProperty("problem");
                    String solution = (String) result.getProperty("solution");
                    String assignmentKey = (String) result.getProperty("assignmentKey");
                    String id = (String) result.getProperty("id");
                    QuestionBean newBean = new QuestionBean();
                    newBean.setProblem(problem);
                    newBean.setSolution(solution);
                    newBean.setAssignmentKey(assignmentKey);
                    newBean.setId(id);
                    out.println(newBean.generateJSON());
                    System.out.print("Load question success");
                }
            }
        }
    }
}