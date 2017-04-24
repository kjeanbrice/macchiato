package com.macchiato.controllers.studentcontroller;

import com.google.appengine.api.datastore.*;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.macchiato.beans.CourseBean;
import com.macchiato.beans.CourseListBean;
import com.macchiato.beans.StudentBean;
import com.macchiato.beans.UserBean;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

/**
 * Created by li on 4/17/2017.
 */
@Controller
public class StudentController {
    @RequestMapping(value = "LoadStudent.htm", method = RequestMethod.GET)
    public void loadStudent(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        UserBean currUser;
        CourseListBean currList;
        StudentBean currStudent;
        // LOAD USER
        // Get the current user email and create userType
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        String email = user.getEmail();
        int userType = 0;
        // Check if new login or the same user
        String checkEmail = (String)request.getSession().getAttribute("email");
        if (email.equals(checkEmail)){
            System.out.println("Loading User from session.");
            // If email has been set, no need to get anything just return user JSON
            currUser = new UserBean(email, userType);
        }else{
            // Else check in database if user is in there.
            // Get the datastore.
            DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
            // Create the search keyword.
            Query.Filter email_filter = new Query.FilterPredicate("email", Query.FilterOperator.EQUAL, email.trim());
            // Create the query
            Query q = new Query("user").setFilter(email_filter);
            PreparedQuery pq = datastore.prepare(q);
            // Find the UserBean Entity
            Entity result = pq.asSingleEntity();
            // If no student was found on the database create a new one.
            if(result == null){
                System.out.println("No User, creating and saving one now.");
                // Create an Entity to store
                Entity userEntity = new Entity("user",email);
                userEntity.setProperty("email", email);
                userEntity.setProperty("userType", Integer.toString(userType));
                datastore.put(userEntity);
            }else{
                System.out.println("Found User, loading User in now.");
                // Extract the information from result
                email = (String)result.getProperty("email");
                userType = Integer.parseInt((String)result.getProperty("userType"));
                System.out.println(email);
                System.out.println(userType);
            }
            request.getSession().setAttribute("email", email);
            request.getSession().setAttribute("userType", Integer.toString(userType));
            currUser = new UserBean(email, userType);

            System.out.println(currUser.generateJSON());
        }

        // LOAD COURSE LIST
        ArrayList<String> crsCodes = new ArrayList<String>();
        ArrayList<CourseBean> crsList = (ArrayList<CourseBean>) request.getSession().getAttribute("crsList");
        // Check the course list
        if(crsList == null){
            System.out.println("No course list in session");
            // If no course, load it up
            crsList = new ArrayList<CourseBean>();
            // Find all the crsCodes the user is enrolled in.
            DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
            Query.Filter email_filter = new Query.FilterPredicate("email", Query.FilterOperator.EQUAL, email.trim());
            Query q = new Query("enrollment").setFilter(email_filter);
            PreparedQuery pq = datastore.prepare(q);
            for (Entity enrollmentEntity : pq.asIterable()) {
                crsCodes.add((String)enrollmentEntity.getProperty("crsCode"));
            }
            if (crsCodes.size() > 0){
                System.out.println("Loading courses");
                // Find all the courses the user is enrolled in
                Query.Filter crsCode_filter;
                Entity course;
                CourseBean crsBean;
                for (int i = 0; i<crsCodes.size(); i++){
                    crsCode_filter = new Query.FilterPredicate("crsCode", Query.FilterOperator.EQUAL, crsCodes.get(i).trim());
                    q = new Query("course").setFilter(crsCode_filter);
                    pq = datastore.prepare(q);
                    course = pq.asSingleEntity();
                    crsBean = new CourseBean((String)course.getProperty("crsCode"),
                            (String)course.getProperty("crsName"),
                            (String)course.getProperty("instrEmail"),
                            (String)course.getProperty("description"));
                    crsList.add(crsBean);
                }
                request.getSession().setAttribute("crsList", crsList);
            }else{
                System.out.println("User not enrolled in any courses");
            }
        }else{
            System.out.println("Loading Courses from session");
        }

        currList = new CourseListBean(crsList);
        currStudent = new StudentBean(currUser,currList);
        System.out.println(currStudent.generateJSON());
        out.println(currStudent.generateJSON());
    }



    @RequestMapping(value = "LoadStudentAssignments.htm", method = RequestMethod.GET)
    public void loadStudentAssignments(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Email should be set in session
        // crsList of courses should be set in session
        // currCourse should be set in session
        // Find the list of assignments
        // Sort them alphabetically
        // Return them
    }

    public void storeDummyData(){
        // Store 3 dummy courses
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        Entity cse114 = new Entity("course");
        cse114.setProperty("crsCode", "1111");
        cse114.setProperty("crsName", "CSE114");
        cse114.setProperty("instrEmail", "teacher1@gmail.com");
        cse114.setProperty("description", "Hello");
        datastore.put(cse114);
        // Store 1 dummy enrollment
        Entity enrollmentEntity = new Entity("enrollment");
        enrollmentEntity.setProperty("crsCode", "1111");
        enrollmentEntity.setProperty("email", "test@example.com");
        datastore.put(enrollmentEntity);
        // Store 6 dummy assignments
    }
}