<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="Hackathon.Profile" %>


<!DOCTYPE html>
<html lang="en-us">
<head runat="server">
    <meta charset="utf-8">
    <!--<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">-->

    <title>SmartAdmin </title>
    <meta name="description" content="">
    <meta name="author" content="">

    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

    <!-- Basic Styles -->
    <link rel="stylesheet" type="text/css" media="screen" href="smartadmin/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" media="screen" href="smartadmin/css/font-awesome.min.css">

    <!-- SmartAdmin Styles : Caution! DO NOT change the order -->
    <link rel="stylesheet" type="text/css" media="screen" href="smartadmin/css/smartadmin-production-plugins.min.css">
    <link rel="stylesheet" type="text/css" media="screen" href="smartadmin/css/smartadmin-production.min.css">
    <link rel="stylesheet" type="text/css" media="screen" href="smartadmin/css/smartadmin-skins.min.css">
    <link rel="stylesheet" type="text/css" media="screen" href="smartadmin/css/panel.css" />
    <!-- SmartAdmin RTL Support -->
    <link rel="stylesheet" type="text/css" media="screen" href="smartadmin/css/smartadmin-rtl.min.css">

    <!-- We recommend you use "your_style.css" to override SmartAdmin
		     specific styles this will also ensure you retrain your customization with each SmartAdmin update.
		<link rel="stylesheet" type="text/css" media="screen" href="css/your_style.css"> -->

    <!-- Demo purpose only: goes with demo.js, you can delete this css when designing your own WebApp -->
    <link rel="stylesheet" type="text/css" media="screen" href="smartadmin/css/demo.min.css">

    <!-- FAVICONS -->
    <link rel="shortcut icon" href="smartadmin/img/favicon/favicon.ico" type="image/x-icon">
    <link rel="icon" href="smartadmin/img/favicon/favicon.ico" type="image/x-icon">

    <!-- GOOGLE FONT -->
    <link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Open+Sans:400italic,700italic,300,400,700">

    <!-- Specifying a Webpage Icon for Web Clip 
			 Ref: https://developer.apple.com/library/ios/documentation/AppleApplications/Reference/SafariWebContent/ConfiguringWebApplications/ConfiguringWebApplications.html -->
    <link rel="apple-touch-icon" href="smartadmin/img/splash/sptouch-icon-iphone.png">
    <link rel="apple-touch-icon" sizes="76x76" href="smartadmin/img/splash/touch-icon-ipad.png">
    <link rel="apple-touch-icon" sizes="120x120" href="smartadmin/img/splash/touch-icon-iphone-retina.png">
    <link rel="apple-touch-icon" sizes="152x152" href="smartadmin/img/splash/touch-icon-ipad-retina.png">

    <!-- iOS web-app metas : hides Safari UI Components and Changes Status Bar Appearance -->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <script src="smartadmin/js/libs/jquery-2.1.1.min.js"></script>


    <script>

        function profile(data) {
            var id = data['hits']['hits'][0]['_id'];
            var name = data['hits']['hits'][0]['_source']['author_name']
            var follow = data['hits']['hits'][0]['_source']['follower_count'];
            var connect = data['hits']['hits'][0]['_source']['friend_count'];
            var email = data['hits']['hits'][0]['_source']['email'] == null ? "null" : data['hits']['hits'][0]['_source']['email'];
            var hometown = data['hits']['hits'][0]['_source']['hometown'] == null ? "null" : data['hits']['hits'][0]['_source']['hometown'];
            var birthYear = data['hits']['hits'][0]['_source']['birthYear'] == null ? "null" : data['hits']['hits'][0]['_source']['birthYear'];
            var quotes = data['hits']['hits'][0]['_source']['fb_data']['quotes'] == null ? "null" : data['hits']['hits'][0]['_source']['fb_data']['quotes'];
            var phone = data['hits']['hits'][0]['_source']['fb_data']['mobile_phone'];
            var school = data['hits']['hits'][0]['_source']['fb_data']['education'];
            var marrigeSt = data['hits']['hits'][0]['_source']['marrigeStatus'];
            if (marrigeSt == 0)
                $("#userMarrige").text("Single");
            else
                $("#userMarrige").text("Married");
            var schoolHtml = "";
            for (var i = 0; i < school.length; i++) {
                schoolHtml += "<div><i class='fa fa-graduation-cap'></i><a href=https://www.facebook.com/" + school[i]['school']['id'] + "><span style='padding-left:10px;'>" + school[i]['school']['name'] + "</span></a></div>"
            }
            $('#userSchool').prepend(schoolHtml);
            var work = data['hits']['hits'][0]['_source']['fb_data']['work'];
            var workHtml = "";
            for (var i = 0; i < work.length; i++) {
                workHtml += "<div><i class='fa fa-briefcase'></i><a href=https://www.facebook.com/" + work[i]['position']['id'] + "><span style='padding-left:10px;'>" + work[i]['position']['name'] + "</span></a> at <a href=https://www.facebook.com/" + work[i]['employer']['id'] + "><span style='padding-left:10px;'>" + work[i]['employer']['name'] + "</span></a></div>"
            }
            $('#userWork').prepend(workHtml);
            $('#fbUser').attr("href", "https://www.facebook.com/" + id);
            $('#userID').val(id);
            $('#userFollow').text(follow);
            $('#phone').text(phone);
            $('#userName').text(name);
            $('#userConnect').text(connect);
            $('#userEmail').text(email);
            $('#userHomeTown').text(hometown);
            $('#userBirthDay').text(birthYear);
            $('#userQuotes').text(quotes);
            $("#userAvar").attr("src", "http://graph.facebook.com/" + id + "/picture?type=large");
            var idd = $("#userID").val();
            $.ajax({
                type: "POST",
                url: "http://localhost:5000/friends?q=" + idd,
                processData: false,
                contentType: false,
                success: function (data) {
                    getProfileFr(JSON.parse(data));
                }
            });

        };
        function getProfileFr(data) {
            datafr = data['friends'];
            console.log(datafr.length);
            for (var i = 0; i < datafr.length; i++) {
                var influnce = datafr[i]['_source']['influence_score'];
                if (influnce > 6) color = 'score';
                else color = 'danger';
                console.log(color);
                console.log(influnce);
                itemHtml = "";
                itemHtml += "<section class='mention mention-box mention-site-5'>"
                itemHtml += "	<div class='header'>"

                itemHtml += "		<div class='avatar'>"
                itemHtml += "			<a target='_blank' href='http://facebook.com/" + datafr[i]['_id'] + "'><img src='http://graph.facebook.com/" + datafr[i]['_id'] + "/picture'></a>"
                itemHtml += "		</div>"

                itemHtml += "	    <div class='author'>"
                itemHtml += "		    <div class='mention-title-box'>"
                itemHtml += "			    <a target='_blank' href='http://facebook.com/" + datafr[i]['_id'] + "'>" + datafr[i]['_source']["author_name"] + "</a>"
                itemHtml += "		    </div>"
                itemHtml += "           <div class='influence-score'>"
                itemHtml += "               <button onClick='#'  class='btn btn-lg btn-circle btn-" + color + "'>" + influnce + "</button> "
                itemHtml += "           </div>"
                itemHtml += "       </div>"

                itemHtml += "	    <div class='counter'>"
                itemHtml += "            <span> <strong>" + datafr[i]['_source']['friend_count'] + "</strong>  Friends </span>"
                itemHtml += "            <span> <strong>" + datafr[i]['_source']['follower_count'] + "</strong>  Followers </span>"
                itemHtml += "       </div>"

                itemHtml += "	</div>"
                itemHtml += "   <div class='description'>";
                if (datafr[i]['_source'].hasOwnProperty('fb_data')) {
                    if (datafr[i]['_source']['fb_data'].hasOwnProperty('work')) {
                        var works = datafr[i]['_source']['fb_data']['work']
                        for (var j = 0; j < works.length; j++) {
                            var employer = works[j]['employer']['name'];
                            var position = "";
                            var employerid = works[j]['employer']['id'];
                            if (works[j].hasOwnProperty('position'))
                                position = works[j]['position']['name'];

                            if (position)
                                itemHtml += "<p> <i class='fa fa-briefcase' style='padding-right:10px'></i>" + position + ' tại ' + "<a href='http://facebook.com/" + employerid + "'>" + employer + "</a></p>";
                            else
                                itemHtml += "<p> <i class='fa fa-briefcase' style='padding-right:10px'></i> Làm việc tại <a href='http://facebook.com/" + employerid + "'>" + employer + "</a></p>";

                        }
                    }
                }
                itemHtml += "   </div"
                $('#a1').prepend(itemHtml);
            }

        };

        function showAllContent(ele) {
            $(ele).hide();
            $(ele).parent().next().show();
        }

    </script>
    <script>        
        var my_script = document.createElement('script');
        var params = (new URL(document.location)).searchParams;
        var phone = params.get('phone');
        console.log(phone);
        my_script.setAttribute('src', 'http://192.168.1.228:8888/api.aspx?t=profile&q=' + phone);

        document.head.appendChild(my_script);

    </script>


    <!-- Startup image for web apps -->
    <link rel="apple-touch-startup-image" href="smartadmin/img/splash/ipad-landscape.png" media="screen and (min-device-width: 481px) and (max-device-width: 1024px) and (orientation:landscape)">
    <link rel="apple-touch-startup-image" href="smartadmin/img/splash/ipad-portrait.png" media="screen and (min-device-width: 481px) and (max-device-width: 1024px) and (orientation:portrait)">
    <link rel="apple-touch-startup-image" href="smartadmin/img/splash/iphone.png" media="screen and (max-device-width: 320px)">
    <style>
        .home-2 .nav_area {
            background: #078145 none repeat scroll 0 0;
            border-bottom: none;
            padding: 20px 0;
        }

        .nav_area {
            left: 0;
            position: absolute;
            top: 0;
            width: 100%;
            z-index: 9999;
            padding: 33px 0;
            border-bottom: 1px solid #B6B1B1;
            background: transparent;
            background: #078145 none repeat scroll 0 0;
            border-bottom: none;
            padding: 20px 0;
        }

        .stick {
            padding: 15px 0px;
            transition: 1s;
            background: rgba(0, 0, 0, .7);
            position: fixed !important;
            color: #fff;
            background: #078145 none repeat scroll 0 0;
            border-bottom: none;
        }

        .menu {
            padding-top: 10px;
        }

            .menu ul li {
                display: inline;
            }

            .menu ul {
                text-align: right;
            }

                .menu ul li a {
                    display: inline-block;
                    padding: 5px 14px 6px;
                    text-transform: uppercase;
                    color: #323b48;
                    font-weight: bold;
                    font-family: 'Open Sans', sans-serif;
                    -moz-transition: .3s;
                    -webkit-transition: .3s;
                    -o-transition: .3s;
                    -ms-transition: .3s;
                    transition: .3s;
                    line-height: 21px;
                }

            .menu .current > a {
                background: #ffaa31 none repeat scroll 0 0;
                color: #fff;
            }

            .menu .current > a, .menu ul li a:hover {
                background: #53B554 none repeat scroll 0 0;
            }
    </style>
</head>


<body class="" style="padding-top: 50px;">

    <!-- HEADER -->
    <header id="home-2" style="z-index: 905">


        <div class="nav_area stick" id="sticker">
            <div class="container">
                <div class="row">
                    <!--logo area-->
                    <div class="col-md-2 col-sm-2 col-xs-4">
                        <div class="logo">
                            <a href="https://vaytinchap.vpbank.com.vn/LOSWebDE/?utm_source=vpbank.com.vn&amp;utm_medium=referral&amp;utm_campaign=UPL.Generic&amp;utm_content=productpage#vay-tin-chap">
                                <img src="./Vay tín chấp tiêu dùng VPBank - NH Việt Nam Thịnh Vượng_files/logo.png" alt="Vay tín chấp tiêu dùng VPBank">
                            </a>
                        </div>

                    </div>
                    <!--end logo area-->
                    <!--nav area-->
                    <div class="col-md-10 col-sm-10 col-xs-8 ">
                        <div class="menu">
                            <ul class="navid ">
                                <li class="current"><a href="https://vaytinchap.vpbank.com.vn/LOSWebDE/?utm_source=vpbank.com.vn&amp;utm_medium=referral&amp;utm_campaign=UPL.Generic&amp;utm_content=productpage#vay-tin-chap">Vay nhanh</a></li>

                                <li class="vay-ngay"><a href="https://vaytinchap.vpbank.com.vn/LOSWebDE/?utm_source=vpbank.com.vn&amp;utm_medium=referral&amp;utm_campaign=UPL.Generic&amp;utm_content=productpage#vay-ngay">
                                    <img src="./Vay tín chấp tiêu dùng VPBank - NH Việt Nam Thịnh Vượng_files/vpbank-logo-white.png"></a></li>

                            </ul>
                        </div>
                    </div>
                    <!--moblie menu area-->

                    <!--end nav area-->
                </div>
            </div>
        </div>
    </header>

    <div id="main" role="main">

        <!-- RIBBON -->
        <div id="ribbon">

            <span class="ribbon-button-alignment">
                <span id="refresh" class="btn btn-ribbon" data-action="resetWidgets" data-title="refresh" rel="tooltip" data-placement="bottom" data-original-title="<i class='text-warning fa fa-warning'></i> Warning! This will reset all your widget settings." data-html="true">
                    <i class="fa fa-refresh"></i>
                </span>
            </span>

            <!-- breadcrumb -->
            <ol class="breadcrumb">
                <li>Home</li>
                <li>App Views</li>
                <li>Profile</li>
            </ol>


        </div>
        <!-- END RIBBON -->

        <!-- MAIN CONTENT -->
        <div id="content">

            <!-- Bread crumb is created dynamically -->
            <!-- row -->
            <div class="row">

                <!-- col -->
                <div class="col-xs-12 col-sm-7 col-md-7 col-lg-4">
                    <h1 class="page-title txt-color-blueDark">
                        <!-- PAGE HEADER -->
                        <i class="fa-fw fa fa-puzzle-piece"></i>Profile </h1>
                </div>
                <!-- end col -->

                <!-- right side of the page with the sparkline graphs -->
                <!-- col -->
                <div class="col-xs-12 col-sm-5 col-md-5 col-lg-8">
                    <!-- sparks -->

                    <!-- end sparks -->
                </div>
                <!-- end col -->

            </div>
            <!-- end row -->

            <!-- row -->

            <div class="row">

                <div class="col-sm-12">


                    <div class="well well-sm">

                        <div class="row">

                            <div class="col-sm-12 col-md-12 col-lg-6">
                                <div class="well well-light well-sm no-margin no-padding">

                                    <div class="row">


                                        <div class="col-sm-12">

                                            <div class="row">

                                                <div class="col-sm-3 profile-pic">
                                                    <img src="" id="userAvar" alt="demo user">
                                                    <div class="padding-10">
                                                        <h4 class="font-md"><strong><span id="userFollow"></span></strong>
                                                            <br>
                                                            <small>Followers</small></h4>
                                                        <br>
                                                        <h4 class="font-md"><strong><span id="userConnect"></span></strong>
                                                            <br>
                                                            <small>Friends</small></h4>
                                                    </div>
                                                </div>
                                                <div class="col-sm-6">
                                                    <span>
                                                        <h1><span class="semi-bold"><a id="fbUser"><span id="userName"></span></a></span>
                                                            <br>
                                                        </h1>
                                                        <ul class="list-unstyled">
                                                            <li>
                                                                <p class="text-muted">
                                                                    <i class="fa fa-phone"></i>&nbsp;&nbsp;(<span class="txt-color-darken">+84</span>) <span class="txt-color-darken"><span id="phone"></span></span>
                                                                </p>
                                                            </li>
                                                            <li>
                                                                <p class="text-muted">
                                                                    <i class="fa fa-envelope"></i>&nbsp;&nbsp;<a href=""><span id="userEmail"></span></a>
                                                                </p>
                                                            </li>
                                                            <li>
                                                                <p class="text-muted">
                                                                    <i class="fa fa-home"></i>&nbsp;&nbsp;<span class="txt-color-darken"><span id="userHomeTown"></span></span>
                                                                </p>
                                                            </li>
                                                            <li>
                                                                <p class="text-muted">
                                                                    <i class="fa fa-calendar"></i>&nbsp;&nbsp;<span class="txt-color-darken"><span id="userBirthDay"></span></span>
                                                                </p>
                                                            </li>
                                                        </ul>
                                                        <br>
                                                        <p class="font-md">
                                                            <i>Quotes</i>
                                                        </p>
                                                        <p>
                                                            <span id="userQuotes"></span>

                                                        </p>
                                                        
                                                        <a onclick='showAllContent(this);' class="btn btn-default btn-xs"><i class="fa fa-envelope-o"></i>See More</a>
                                                        
                                                    </span>
                                                    <span style="display:none">
                                                        <br>
                                                        <p class="font-md">
                                                            <i>Education</i>
                                                        </p>
                                                        <p>
                                                            <span id="userSchool"></span>

                                                        </p>
                                                        <br>
                                                        <p class="font-md">
                                                            <i>Work</i>
                                                        </p>
                                                        <p>
                                                            <span id="userWork"></span>

                                                        </p>
                                                        <br>
                                                        <p class="font-md">
                                                            <i>Marrige Status</i>
                                                        </p>
                                                        <p>
                                                            <span class="fa fa-heart"></span><span id="userMarrige" style="padding-left:10px"></span>

                                                        </p>
                                                        <br>
                                                    </span>
                                                </div>

                                            </div>

                                        </div>

                                    </div>

                                    <div class="row">

                                        <div class="col-sm-12">

                                            <hr>

                                            <div class="padding-10">

                                                <ul class="nav nav-tabs tabs-pull-right">
                                                    <li class="active">
                                                        <a href="#a1" data-toggle="tab">Influence Score</a>
                                                    </li>

                                                    <li class="pull-left">
                                                        <span class="margin-top-10 display-inline"><i class="fa fa-rss text-success"></i>Top Friends</span>
                                                    </li>
                                                </ul>

                                                <div class="tab-content padding-top-10">
                                                    <div class="tab-pane fade in active" id="a1">
                                                    </div>

                                                    <!-- end tab -->
                                                </div>

                                            </div>

                                        </div>

                                    </div>
                                    <!-- end row -->

                                </div>

                            </div>
                            <div class="col-sm-12 col-md-12 col-lg-6">

                                <div class="timeline-seperator text-center" style="padding-bottom: 10px;margin: 0;color: red;">
                                    <span>Recent Posts</span>

                                </div>
                                <div id="a3"></div>

                            </div>
                        </div>

                    </div>


                </div>

            </div>

            <!-- end row -->

        </div>
        <!-- END MAIN CONTENT -->

    </div>
    <!-- END MAIN PANEL -->

    <!-- PAGE FOOTER -->
    <div class="page-footer">
        <div class="row">
            <div class="col-xs-12 col-sm-6">
                <span class="txt-color-white">SmartAdmin 1.8.2 <span class="hidden-xs">- Web Application Framework</span> © 2014-2015</span>
            </div>

            <div class="col-xs-6 col-sm-6 text-right hidden-xs">
                <div class="txt-color-white inline-block">
                    <i class="txt-color-blueLight hidden-mobile">Last account activity <i class="fa fa-clock-o"></i><strong>52 mins ago &nbsp;</strong> </i>
                    <div class="btn-group dropup">
                        <button class="btn btn-xs dropdown-toggle bg-color-blue txt-color-white" data-toggle="dropdown">
                            <i class="fa fa-link"></i><span class="caret"></span>
                        </button>
                        <ul class="dropdown-menu pull-right text-left">
                            <li>
                                <div class="padding-5">
                                    <p class="txt-color-darken font-sm no-margin">Download Progress</p>
                                    <div class="progress progress-micro no-margin">
                                        <div class="progress-bar progress-bar-success" style="width: 50%;"></div>
                                    </div>
                                </div>
                            </li>
                            <li class="divider"></li>
                            <li>
                                <div class="padding-5">
                                    <p class="txt-color-darken font-sm no-margin">Server Load</p>
                                    <div class="progress progress-micro no-margin">
                                        <div class="progress-bar progress-bar-success" style="width: 20%;"></div>
                                    </div>
                                </div>
                            </li>
                            <li class="divider"></li>
                            <li>
                                <div class="padding-5">
                                    <p class="txt-color-darken font-sm no-margin">Memory Load <span class="text-danger">*critical*</span></p>
                                    <div class="progress progress-micro no-margin">
                                        <div class="progress-bar progress-bar-danger" style="width: 70%;"></div>
                                    </div>
                                </div>
                            </li>
                            <li class="divider"></li>
                            <li>
                                <div class="padding-5">
                                    <button class="btn btn-block btn-default">refresh</button>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- END PAGE FOOTER -->

    <!-- SHORTCUT AREA : With large tiles (activated via clicking user name tag)
		Note: These tiles are completely responsive,
		you can add as many as you like
		-->
    <div id="shortcut">
        <ul>
            <li>
                <a href="inbox.html" class="jarvismetro-tile big-cubes bg-color-blue"><span class="iconbox"><i class="fa fa-envelope fa-4x"></i><span>Mail <span class="label pull-right bg-color-darken">14</span></span> </span></a>
            </li>
            <li>
                <a href="calendar.html" class="jarvismetro-tile big-cubes bg-color-orangeDark"><span class="iconbox"><i class="fa fa-calendar fa-4x"></i><span>Calendar</span> </span></a>
            </li>
            <li>
                <a href="gmap-xml.html" class="jarvismetro-tile big-cubes bg-color-purple"><span class="iconbox"><i class="fa fa-map-marker fa-4x"></i><span>Maps</span> </span></a>
            </li>
            <li>
                <a href="invoice.html" class="jarvismetro-tile big-cubes bg-color-blueDark"><span class="iconbox"><i class="fa fa-book fa-4x"></i><span>Invoice <span class="label pull-right bg-color-darken">99</span></span> </span></a>
            </li>
            <li>
                <a href="gallery.html" class="jarvismetro-tile big-cubes bg-color-greenLight"><span class="iconbox"><i class="fa fa-picture-o fa-4x"></i><span>Gallery </span></span></a>
            </li>
            <li>
                <a href="profile.html" class="jarvismetro-tile big-cubes selected bg-color-pinkDark"><span class="iconbox"><i class="fa fa-user fa-4x"></i><span>My Profile </span></span></a>
            </li>
        </ul>
    </div>


    <!-- END SHORTCUT AREA -->
    <form runat="server">
        <asp:HiddenField ID="userID" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="userPhone" ClientIDMode="Static" runat="server" />
    </form>



    <!--================================================== -->

    <!-- PACE LOADER - turn this on if you want ajax loading to show (caution: uses lots of memory on iDevices)-->
    <script data-pace-options='{ "restartOnRequestAfter": true }' src="smartadmin/js/plugin/pace/pace.min.js"></script>

    <!-- Link to Google CDN's jQuery + jQueryUI; fall back to local -->
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script>
        if (!window.jQuery) {
            document.write('<script src="js/libs/jquery-2.1.1.min.js"><\/script>');
        }
    </script>

    <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js"></script>
    <script>
        if (!window.jQuery.ui) {
            document.write('<script src="js/libs/jquery-ui-1.10.3.min.js"><\/script>');
        }
    </script>

    <!-- IMPORTANT: APP CONFIG -->
    <script src="smartadmin/js/app.config.js"></script>

    <!-- JS TOUCH : include this plugin for mobile drag / drop touch events-->
    <script src="smartadmin/js/plugin/jquery-touch/jquery.ui.touch-punch.min.js"></script>

    <!-- BOOTSTRAP JS -->
    <script src="smartadmin/js/bootstrap/bootstrap.min.js"></script>
    <!-- CUSTOM NOTIFICATION -->
    <script src="smartadmin/js/notification/SmartNotification.min.js"></script>

    <!-- JARVIS WIDGETS -->
    <script src="smartadmin/js/smartwidgets/jarvis.widget.min.js"></script>

    <!-- EASY PIE CHARTS -->
    <script src="smartadmin/js/plugin/easy-pie-chart/jquery.easy-pie-chart.min.js"></script>

    <!-- SPARKLINES -->
    <script src="smartadmin/js/plugin/sparkline/jquery.sparkline.min.js"></script>

    <!-- JQUERY VALIDATE -->
    <script src="smartadmin/js/plugin/jquery-validate/jquery.validate.min.js"></script>

    <!-- JQUERY MASKED INPUT -->
    <script src="smartadmin/js/plugin/masked-input/jquery.maskedinput.min.js"></script>

    <!-- JQUERY SELECT2 INPUT -->
    <script src="smartadmin/js/plugin/select2/select2.min.js"></script>

    <!-- JQUERY UI + Bootstrap Slider -->
    <script src="smartadmin/js/plugin/bootstrap-slider/bootstrap-slider.min.js"></script>

    <!-- browser msie issue fix -->
    <script src="smartadmin/js/plugin/msie-fix/jquery.mb.browser.min.js"></script>

    <!-- FastClick: For mobile devices -->
    <script src="smartadmin/js/plugin/fastclick/fastclick.min.js"></script>

    <!--[if IE 8]>

		<h1>Your browser is out of date, please update your browser by going to www.microsoft.com/download</h1>

		<![endif]-->

    <!-- Demo purpose only -->
    <script src="smartadmin/js/demo.min.js"></script>

    <!-- MAIN APP JS FILE -->
    <script src="smartadmin/js/app.min.js"></script>

    <!-- ENHANCEMENT PLUGINS : NOT A REQUIREMENT -->
    <!-- Voice command : plugin -->
    <script src="smartadmin/js/speech/voicecommand.min.js"></script>

    <!-- SmartChat UI : plugin -->
    <script src="smartadmin/js/smart-chat-ui/smart.chat.ui.min.js"></script>
    <script src="smartadmin/js/smart-chat-ui/smart.chat.manager.min.js"></script>

    <!-- PAGE RELATED PLUGIN(S) 
		<script src="..."></script>-->

    <script type="text/javascript">

        // DO NOT REMOVE : GLOBAL FUNCTIONS!

        $(document).ready(function () {

            pageSetUp();

        })

    </script>

    <!-- Your GOOGLE ANALYTICS CODE Below -->
    <script type="text/javascript">
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', 'UA-XXXXXXXX-X']);
        _gaq.push(['_trackPageview']);

        (function () {
            var ga = document.createElement('script');
            ga.type = 'text/javascript';
            ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0];
            s.parentNode.insertBefore(ga, s);
        })();

    </script>
    <script>
        function calculateTimeforDisplay(date) {
            var d1 = new Date(date).getTime();
            var d2 = new Date().getTime();
            var diff = d2 - d1;
            var time = "";
            if (diff >= 0 && diff < 6000) time = "vừa đăng";
            else if (diff < 3600000 && diff >= 6000) time = Math.floor(diff / 60000) + " phút trước";
            else if (diff < 86400000 && diff >= 3600000) time = Math.floor(diff / 3600000) + " giờ trước";
            else if (diff < 604800000 && diff >= 86400000) {
                var day = Math.floor(diff / 86400000);
                time = day + " ngày " + Math.floor((diff - day * 86400000) / 3600000) + " " + " giờ trước";
            }
            else if (diff >= 604800000 || diff < 0) time = date;
            return time;
        }
        window.onload = function () {
            var id = $('#userID').val();
            console.log(id);
            $.ajax({
                type: "POST",
                url: "http://localhost:5000/post?q=" + id,
                processData: false,
                contentType: false,
                success: function (data) {
                    post_callback(data)
                }
            }); // 4th
        };

        function post_callback(data) {
            var jsondata = JSON.parse(data);
            var posts = jsondata['hits']['hits'];

            for (var i = 0; i < posts.length; i++) {
                var message = posts[i]['_source']['message'];
                var content = message.replace(/<\s*script|javascript:|script\s*>/gi, ' ');
                var timeCreate = posts[i]['_source']['createDate'];
                var author = posts[i]['_source']['author'];
                console.log(posts[i]['_source']['insideUrl']);
                var displayTime = calculateTimeforDisplay(timeCreate);
                var itemHtml = "";
                itemHtml += "<section class='mention mention-box mention-site-5'>"
                itemHtml += "	<div class='header'>"
                itemHtml += "		<div class='avatar'>"
                itemHtml += "			<a target='_blank' href='" + author["author_url"] + "'><img src='" + author["author_avatar_url"] + "' onerror='ImageError(this)'></a>"
                itemHtml += "		</div>"
                itemHtml += "	    <div class='author'>"
                itemHtml += "		    <div class='mention-title-box'>"
                itemHtml += "			    <a target='_blank' href='http://facebook.com/" + posts[i]['_source']['id'] + "'>" + author["author_name"] + "</a>"
                itemHtml += "		    </div>"

                itemHtml += "		    <div class='mention-source'>"
                itemHtml += "<a  data - toggle='tooltip' data - container='body' placement = 'top' title = '" + timeCreate + "' > <i class='fa fa-clock-o'></i>" + displayTime + "</a >"
                itemHtml += "		    </div>"
                itemHtml += "		</div>"
                itemHtml += "	</div>"
                itemHtml += "	<div class='description'>"
                itemHtml += "<tr>"
                itemHtml += '<td id="text_915121302012876" style="float:left;margin-top:15px;">'
                itemHtml += "<p class='mention_text'>" + content + "</p>"
                itemHtml += "</td>"
                itemHtml += "<tr/>"
                itemHtml += "	</div>"



                $('#a3').prepend(itemHtml);

            }
        }
    </script>
</body>

</html>
