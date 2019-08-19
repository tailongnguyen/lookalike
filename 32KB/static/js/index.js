function initLayout(){
  var screenHeight = $("body").height();
  var screenWidth = $("body").width();

  var inputHeight = $("#input").height();
  var inputWidth = $("#input").width();
  
  var resultHeight = $("#result").height();
  var resultWidth = $("#result").width();

  var logoHeight = $("#logo img").height();
  var logoWidth = $("#logo img").width();

  var iconHeight = $("#loading-gif").height();
  var iconWidth = $("#loading-gif").width();

  $("#input").css({
    "position": "absolute",
    "top": screenHeight / 2 - inputHeight / 2,
    "left": screenWidth / 2 - inputWidth / 2
  })

  $("#result").css({
    "position": "absolute",
    "display": "none",
    "top": logoHeight - 100,
    "left": screenWidth / 2 - resultWidth / 2
  })
  
  $("#logo").css({
    "position": "absolute",
    "height": 300,
    "top": '5%',
    "left": screenWidth / 2 - logoWidth / 2
  })
  
  $("#loading-gif").css({
    'position': "absolute",
    "top": "50%", 
    "left": screenWidth / 2 - iconWidth / 2
  })
}

function reload() {
  window.location.reload()
}

function showResult(){
  $("#logo").addClass('slide-top');
  $("#input").fadeOut(500);
  $("#loading-gif").fadeIn(500);
  var data;

    data = new FormData();
    data.append('key', $("#phone").val());
  $.ajax({
    type: "POST",
    processData: false,
    contentType: false,
    url: "http://192.168.1.228:8887/Api.aspx?t=lookalike",
    
    data: data,
    complete: function(data){
      console.log(data["responseText"]);
      getListUser(data["responseText"]);
      $("#result").delay(500).fadeIn(500);
    }
  })

  
}
function getListUser(data){
  var list = data.split(",");
  var str="";
  list.forEach(element => {
    var d = element.split(":")
    str+= "<tr onclick='trclick(" + d[0] +")'>";
    str+="<td class=\"col-xs-3\">"+d[0]+"</td>";
    str+="<td class=\"col-xs-3\">"+d[1]+"</td>";
    str+="<td class=\"col-xs-6\">"+d[2]+"</td>";
    str+="</tr>";
    return str;
  });
  $('#result > table > tbody').append(str);
  $("#loading-gif").fadeOut(500);
}
function fetchUserInfo(userID){
  $("#loading-gif").fadeIn(500);
  $.ajax({
    type: "GET",
    url: "http://192.168.1.228:8887/api.aspx?t=profile&q=" + userID,
    complete: function (data){
    
      console.log("data", data);
      var a = data['responseText'];      
      var rawUserData = $.parseJSON(a);
      userData = rawUserData['hits']['hits'][0]['_source'];
      console.log(userData);
      
      const userName = userData['fb_data']['name'];
      const userAvatar =  userData['author_avatar_url'];
      const numFriends = userData['friend_count'];
      const numFollowers = userData['follower_count'];
      const birthYear = userData['birthYear'];
      const city = userData['current_city'];
      const hometown = userData['hometown'];
      const email = userData['email'];

      var phoneNumber = "";
      if (userData['phone_mobile'] == "0") {
        phoneNumber = userData['fb_data']['mobile_phone'];
      } else {
        phoneNumber = userData['phone_mobile'];
        
      }

      const education = userData['fb_data']['education'] != null ? userData['fb_data']['education'] : [];
      const work = userData['fb_data']['work'] != null ? userData['fb_data']['work'] : [];

      $("#username").text(userName);
      $("#username").attr("href", "https://www.facebook.com/" + rawUserData['hits']['hits'][0]['_id'] + "/about");

      $("#friend-cnt").text(numFriends + " friends");
      $("#follower-cnt").text(numFollowers + " followers");
      $("#profile-picture").attr('src', userAvatar);
      $("#birth-year").text(birthYear);
      $("#hometown").text(hometown);
      $("#citu").text(city);
      $("#email").text(email);
      $("#phone-number").text(phoneNumber);

      $("#work").html("");
      $("#education").html("");

      education.forEach(element => {
        $("#education").append($(`
          <div style="text-align: left">
              <i class="fa fa-graduation-cap"></i>
              <a href="https://www.facebook.com/` + element['school']['id'] + `">
                  <span style="padding-left: 10px;">` + element['school']['name'] + `</span>

              </a>

          </div>
        `))
        
      });

      work.forEach(element => {
        $("#work").append($(`
        <div style="text-align: left">
            <i class="fa fa-briefcase"></i>
            
            <a href="https://www.facebook.com/` + element['employer']['id'] + `">
                <span style="padding-left: 10px;">` +  element['employer']['name'] + `</span>
            </a>
        </div>
        `))
      });

      $("#loading-gif").fadeOut(500);
      $("#user-info").delay(900).fadeIn(500);
    }
  });
}

function submit() {
  var data;

    data = new FormData();
    data.append('key', "560381171 100003009723895" );
  $.ajax({
    type: "POST",
    processData: false,
    contentType: false,
    url: "http://localhost:1111/Api.aspx?t=getphone",
    
    data: data,
    complete: function(data){
      alert(data);
      
    }
  })
}
function trclick(user_id){
  $("#logo").addClass("horizTranslate");
    $("#result").addClass("horizTranslate");
    //var user_id = $(this).parent().find(".col-xs-6").text();
    console.log("user_id: ", user_id);
    fetchUserInfo(user_id);
    $.ajax({
      type: "GET",
      url: "http://192.168.1.228:8887/api.aspx?t=topfriend&q=" + user_id,
      processData: false,
      contentType: false,
      success: function (data) {
        console.log(data);
          topFriendApi(data);
      },
      error: function () {

          console.log("error top friend");
      }
  });
}
$(document).ready(function(){
  console.log( "ready!" );
  initLayout();
  $("td").click(function(){
    $("#logo").addClass("horizTranslate");
    $("#result").addClass("horizTranslate");
    var user_id = $(this).parent().find(".col-xs-6").text();
    console.log("user_id: ", user_id);
    
    fetchUserInfo(user_id);
  });
  
})
function topFriendApi(dataJson) {
  $(".carousel-inner").html("");
  var datafr = dataJson['topfriend'];
  itemHtml = "";
  for (var i = 0; i < datafr.length; i++) {
      
      if ((i == 0)|| ((i % 3)==0)) {
          if (i == 0)
              itemHtml += "<div class=\"carousel-item active\">";
          else {
              itemHtml += "</div>";
              itemHtml += "<div class=\"carousel-item\">";
          }
      }
      itemHtml += "<div class=\"col-md-4 float-left\">";
      itemHtml += "    <div class=\"card \" style=\"align-items: center;\">";
     
      itemHtml += "        <img class=\"card-img-top card-img\" src=\"http://graph.facebook.com/" + datafr[i]["id"]+"/picture?type=large\" alt=\"Card image cap\">";
      itemHtml += "           <div class=\"card-body card-user\">";
      itemHtml += "                <h4>"+ datafr[i]["name"]+"</h4>";
      itemHtml += "            </div>";
    
      itemHtml += "           <div class=\"card-score\" style=\"padding-top:0.75rem\"> ";
      itemHtml += "               <span>Số điểm tương đồng : <strong>" + datafr[i]["similar_score"] +"</strong></span>";
      itemHtml += "            </div>";
      // itemHtml += "           <div style=\"padding-bottom:0.75rem\">";
      // itemHtml += "              <span>Số lần tag nhau : <strong>" + datafr[i]["tag_score"] +"</strong></span>";
      // itemHtml += "            </div>";
      itemHtml += "   </div>";
      itemHtml += "</div>";
      
      
  }
  itemHtml += "</div>";
  $('#kycSlide > .carousel-inner').append(itemHtml);
}