<%--
  Created by IntelliJ IDEA.
  User: Xiangbin
  Date: 4/19/2017
  Time: 3:31 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Macchiato</title>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">
    <link rel="stylesheet" href="css/app.css">
    <link href="https://fonts.googleapis.com/css?family=Cormorant" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Open+Sans" rel="stylesheet">
</head>

<body>
<!-- TOP BAR -->
<div class="top-bar-container " data-sticky-container>
    <div class="sticky" data-sticky data-options="stickTo:top; marginTop:0; stickyOn:small;" data-check-every="0">
        <div class="top-bar">
            <div class="top-bar-left">
                <ul class="menu">
                    <li><img src="images/Macchiato.png" alt="Mock Image" height="32" width="32"></li>
                    <li><a href="javascript:void(0);" class="scroll-nav logo-name">Macchiato</a></li>

                </ul>
            </div>
            <div class="top-bar-right">
                <ul id = "home-area" class="dropdown menu">
                    <li style="visibility: hidden;"><a href="javascript:void(0)" class="project-btn-styles scroll-nav">Invalid</a></li>
                </ul>
            </div>
        </div>
    </div>
</div>
<!-- END TOP BAR -->

<!-- Add Modal -->
<div aria-hidden="true" aria-labelledby="myModalLabel" role="dialog" tabindex="-1" id="add_modal" class="modal fade"
     style="display: none;">
    <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" id="close_add_modal">&times;</button>
                <h5 class="modal-title">CREATE COURSE</h5>
            </div>
            <input id="course_name_text" type="text" name="name" id="name"
                   placeholder="Type your course name here..."/>&nbsp;&nbsp;
            <br>
            <div class="form-group">
                <textarea id="course_section_text" name="classDis" class="form-control" rows="1"
                          placeholder="Write your section here..."
                ></textarea>
            </div>
            <div class="form-group">
                <textarea id="course_dis_text" name="classDis" class="form-control" rows="10"
                          placeholder="Write your description content here..."
                ></textarea>
            </div>

            <span id="val-editCourse" data-comment-crdCode="" style="display:none;"></span>

            <div id="add_course_submit" class="menu modal-area btn-post-submit" >
                <span class="modal-btn-full">CREATE</span>
            </div>

            <div class="modal-footer">
            </div>
        </div>
    </div>
</div>

<!-- information Modal -->
<div aria-hidden="true" aria-labelledby="myModalLabel" role="dialog" tabindex="-1" id="info_modal" class="modal fade"
     style="display: none;">
    <!-- Modal content-->
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" id="close_information_modal">&times;</button>
                <h4 class="modal-title">Edit Course Information</h4>
            </div>
            <br>
            <div class="form-group">
                Course Description:
                <textarea id="change_course_dis_text" name="classDis" class="form-control" rows="10" id="ccomment"
                          placeholder="Write your description content here..."
                ></textarea>
            </div>

            <div id="info_course_submit" class="menu modal-area btn-post-submit" >
                <span class="modal-btn-full">SUBMIT</span>
            </div>
            <div class="modal-footer">
            </div>
        </div>
    </div>
</div>


<div class="container-fluid text-center">
    <div>.</div>
    <div>.</div>
    <div>.</div>
    <div>.</div>
    <span id ="i_email" data-iemail="${i_email}" style="display:none;"></span>
    <div class="row content">
        <div class="col-sm-8 text-left">
            <h1>Welcome</h1>
            <p>MACCHIATO is a web-application that provides a platform for Computer Science professor to assign to students to solve.
                Students will be able to ask the professors questions on the Discussion Board anything they need and can talk amongst themselves.</p>
            <hr>
        </div>
        <div class="col-sm-1">
            <div>
                <table class="table table-striped">
                    <tbody>
                    <tr>
                        <td><div class="container">
                            <table>
                                <thead>
                                <tr>
                                    <th>Course Name</th>
                                    <th>Section</th>
                                    <th>Description</th>
                                    <th>Assignments</th>
                                    <th>Enroll Code</th>
                                </tr>
                                </thead>
                                <tbody id="item_area" class="tbody-default">
                                </tbody>
                            </table>
                        </div></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script id= "home-page-template" type="text/x-handle-template">
    {{#if User}}
    <li style="visibility: hidden;"><a href="javascript:void(0)" class="project-btn-styles scroll-nav">Invalid</a></li>
    <li>
        <a id="current-user" href="javascript:void(0)" data-username="{{User.email}}" class="scroll-nav welcome-name ">Hi, {{User.email}}</a>
    </li>
    <li><a href="/{{User.home}}" class="scroll-nav link-highlight">Home</a></li>
    <li >
        <a id = "nav_forum"  href="javascript:void(0)" class="scroll-nav link">Forum</a>
        <ul id = "load_forum_area" class="menu forum-links submenu-test">

        </ul>
        <form id="link-form" action=" " method="post" style="display: none;">
            <input name = "i_email" id = "form-iemail" type = "text" style="display:none;">
            <input name = "course" id = "form-course" type = "text" style="display:none;">
            <input name = "section" id = "form-section" type = "text" style="display:none;">
        </form>
    </li>
    <li>
        <a href="/login.htm?access=-1" class="scroll-nav link">Logout</a>
    </li>
    <li>
        <button type="button" class="btn btn-danger navbar-btn" data-toggle="modal" data-target="#add_modal">CREATE A CLASS</button>
    </li>
    {{else}}
    <li>
        <a href="javascript:void(0)" data-username="{{User.email}}" class="scroll-nav welcome-name ">You're not logged in!</a>
    </li>
    <li>
        <a href="/Home.htm" class="scroll-nav link">Go to login portal</a>
    </li>
    {{/if}}
</script>


<script id="discussion-list-template" type="text/x-handle-template">

    {{#each Courses}}
    <li style="white-space: nowrap;" class="list_file" data-list-email="{{instructorEmail}}" data-course="{{course}}" data-section="{{section}}">
        <a class ="list-size" href="javascript:void(0)">{{course}}: {{section}}</a>
    </li>
    {{else}}
    <li><a class ="list-size" href="javascript:void(0)">None Available</a></li>
    {{/each}}

</script>

<!-- Latest compiled and minified JavaScript -->
<script src="https://code.jquery.com/jquery-3.2.0.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.1.1.min.js" type="text/javascript"></script>
<script src="libs/handlebars-v4.0.5.js" type="text/javascript"></script>
<script src="js/nav_bar_transactions.js" type="text/javascript"></script>
<script src="js/teacher_transactions.js"></script>
<script src="js/vendor/jquery.js"></script>
<script src="js/vendor/what-input.js"></script>
<script src="js/vendor/foundation.js"></script>
<script src="js/app.js"></script>
</body>


</html>