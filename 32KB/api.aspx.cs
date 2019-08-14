using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Elasticsearch.Net;
using Nest;

namespace HackathonApi
{
    public partial class api : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string ApiType = Request.QueryString["t"].ToString();
                string Query = Request.QueryString["q"].ToString();
                string ReturnString = string.Empty;
                WebClient client = new WebClient();
                var node = new Uri("http://192.168.36.254:9200");
                var settings = new ConnectionSettings(node);
                var eclient = new ElasticClient(settings);
                client.Encoding = Encoding.UTF8;
                switch (ApiType)
                {
                    case "profile":
                        ReturnString = "profile("+ client.DownloadString("http://192.168.36.254:9200/fb_author_data/authordata/_search?q=" + Query) + ")"; 
                        break;
                    case "network":
                        string RawList = client.DownloadString("http://192.168.35.245:8080/fb/friend/" + Query);
                        string[] AllIdInThisList = RawList.Split(new string[] { " " },StringSplitOptions.RemoveEmptyEntries);
                        StringBuilder ListSB = new StringBuilder();
                        foreach(string l in AllIdInThisList)
                        {
                            ListSB.Append("\"" + l + "\",");
                        }
                       

                        var SearchResponseNet = eclient.LowLevel.Search<StringResponse>("fb_author_data", "authordata", "{\"from\":0,\"size\":100, \"query\": { \"ids\": { \"type\": \"authordata\", \"values\": [ " + ListSB.ToString().TrimEnd(',') + " ] } }, \"_source\": [ \"author_name\", \"follower_count\", \"friend_count\", \"fb_data.work\", \"influence_score\" ] , \"sort\" : [ { \"influence_score\" : {\"order\" : \"desc\"}}]}", null);
                        ReturnString = "network([" + SearchResponseNet.Body.ToString() + "])";
                        break;

                    case "post":
                        ReturnString = "post(" + client.DownloadString("http://192.168.36.254:9200/post_2019_07/_search?q=" + Query) + ")";
                        break;
                    case "friends":
                        string[] IdArray = Query.Split(new char[] { '_' }, StringSplitOptions.RemoveEmptyEntries);
                        List<string> CurrentList = new List<string>();
                        string FirstList = client.DownloadString("http://192.168.35.245:8080/fb/friend/" + IdArray[0]);
                        CurrentList = FirstList.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries).ToList();
                        for(int i=1; i<IdArray.Length; i++)
                        {
                            if (CurrentList.Count == 0) break;
                            else
                            {
                                string ThisList = client.DownloadString("http://192.168.35.245:8080/fb/friend/" + IdArray[i]);
                                List<string> ThisCurrentList = ThisList.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries).ToList();
                                CurrentList = CurrentList.Intersect(ThisCurrentList).ToList();
                            }
                        }
                        if(CurrentList.Count > 0)
                        {
                            StringBuilder sb = new StringBuilder();
                            foreach (string s in CurrentList) sb.Append(s + " ");
                            ReturnString = sb.ToString().Trim();
                        }
                        string RawList1 = ReturnString;
                        string[] AllIdInThisList1 = RawList1.Split(new string[] { " " }, StringSplitOptions.RemoveEmptyEntries);
                        StringBuilder ListSB1 = new StringBuilder();
                        foreach (string l in AllIdInThisList1)
                        {
                            ListSB1.Append("\"" + l + "\",");
                        }
                        

                        

                        var SearchResponseFriend = eclient.LowLevel.Search<StringResponse>("fb_author_data", "authordata", "{\"from\":0,\"size\":100, \"query\": { \"ids\": { \"type\": \"authordata\", \"values\": [ " + ListSB1.ToString().TrimEnd(',') + " ] } }, \"_source\": [ \"author_name\", \"follower_count\", \"friend_count\", \"fb_data.work\", \"influence_score\" ], \"sort\" : [ { \"influence_score\" : {\"order\" : \"desc\"}}] }", null);
                        ReturnString = "friends([" + SearchResponseFriend.Body.ToString() + "])";
                        break;
                }
                Response.ContentEncoding = Encoding.UTF8;
                Response.ContentType = "text/json";
                Response.Write(ReturnString);
            }
            catch { }
        }
    }
}