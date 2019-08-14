function initLayout(){
  var screenHeight = $("body").height();
  var screenWidth = $("body").width();

  var inputHeight = $("#input").height();
  var inputWidth = $("#input").width();
  
  var resultHeight = $("#result").height();
  var resultWidth = $("#result").width();

  var logoHeight = $("#logo img").height();
  var logoWidth = $("#logo img").width();

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

  console.log(screenWidth, logoWidth);
  
  $("#logo").css({
    "position": "absolute",
    "height": 300,
    "top": '5%',
    "left": screenWidth / 2 - logoWidth / 2
  })
}

function showResult(){
  $("#logo").addClass('slide-top');
  $("#input").fadeOut(500);
  $("#result").delay(500).fadeIn(500);
}

function fetchUserInfo(userID){
  $.ajax({
    type: "GET",
    url: "http://192.168.1.228:8888/api.aspx?t=profile&q=" + userID,
    complete: function (data){
    
      console.log("data", data);
      var a = data['responseText'];      
      var userData = $.parseJSON(a.slice(8, a.length - 1));
      userData = userData['hits']['hits'][0]['_source'];
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

      const education = userData['fb_data']['education'];
      const work = userData['fb_data']['work'];

      $("#username").text(userName);
      $("#friend-cnt").text(numFriends + " friends");
      $("#follower-cnt").text(numFollowers + " followers");
      $("#profile-picture").attr('src', userAvatar);
      $("#birth-year").text(birthYear);
      $("#hometown").text(hometown);
      $("#citu").text(city);
      $("#email").text(email);
      $("#phone-number").text(phoneNumber);

      education.forEach(element => {
        $("#education").append($(`
          <div style="text-align: left">
              <i class="fa fa-graduation-cap"></i>
              <a href="https://www.facebook.com/%` + element['school']['id'] + `">
                  <span style="padding-left: 10px;">` + element['school']['name'] + `</span>

              </a>

          </div>
        `))
        
      });

      work.forEach(element => {
        $("#work").append($(`
        <div style="text-align: left">
            <i class="fa fa-briefcase"></i>
            
            <a href="https://www.facebook.com/%` + element['employer']['id'] + `">
                <span style="padding-left: 10px;">` +  element['employer']['name'] + `</span>
            </a>
        </div>
        `))
      });

      $("#user-info").delay(900).fadeIn(500);
    }
  });
}

function submit() {
  $.ajax({
    type: "POST",
    xhrFields: {
      withCredentials: true
    },
    url: "http://192.168.30.10:1111/Api.aspx?t=getphone",
    dataType: 'text/json', 
    data: "560381171 100003009723895",
    complete: function(data){
      console.log(data);
      
    }
  })
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