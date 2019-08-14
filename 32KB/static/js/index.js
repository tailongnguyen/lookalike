// int size_get = list_id.Count * 2;
// Dictionary<string, int> list_weight_friend = new Dictionary<string, int>();
// string urlData = String.Empty;
// WebClient wc = new WebClient(); 
// foreach (string id in list_id)
// {
//     urlData = wc.DownloadString("http://192.168.1.228:8889/default.aspx?id=" + id).Trim();
//     List<string> listFriend = urlData.Split(' ').ToList();
//     foreach (string fr in listFriend)
//     {
//         //neu da co trong dictionary
//         if (list_weight_friend.ContainsKey(fr))
//         {
//             int temp_w = list_weight_friend[fr];
//             list_weight_friend[fr] = temp_w + 1;
//         }
//         //neu chua co trong dictionary
//         else
//         {
//             list_weight_friend[fr] = 1;
//         }
//     }
// }
// var list_weight_friend_sorted = list_weight_friend.OrderBy(key => key.Value);
// var size_of_list_friend = list_weight_friend_sorted.Count();
// var results = new Dictionary<string, int>();
// var count = 0;
// for (int i = size_of_list_friend - 1; i >= 0; i--)
// {
//     count++;
//     if (count > size_get) break;
//     results[list_weight_friend_sorted.ElementAt(i).Key] = list_weight_friend_sorted.ElementAt(i).Value;
// }

// List<string> rs = new List<string>();
// foreach (KeyValuePair<string, int> entry in results)
// {
//     rs.Add(entry.Key);
// }
// return rs;

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

$(document).ready(function(){
  console.log( "ready!" );
  initLayout();
  $("td").click(function(){
    $("#logo").addClass("horizTranslate");
    $("#result").addClass("horizTranslate");
    $("#user-info").delay(500).fadeIn(500);
  });
  
})