<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="java.util.Arrays"%>
<%@page import="java.util.Map"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.IOException"%>

<!DOCTYPE html>
<html>
  <title>Red Hat UKI Forum ConfigMap Example</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

  <link rel="icon" type="image/x-icon" href="images/favicon.ico">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

  <style>
    /* Set height of the grid so .sidenav can be 100% (adjust if needed) */
    .row.content {height: 500px}
    
    /* Set gray background color and 100% height */
    .sidenav {
      background-color: #f1f1f1;
      height: 100%;
    }

    .webserviceoutput {
      background-color: green;
      color: white;
      padding: 2px;
    }
    
    /* Set black background color, white text and some padding */
    footer {
      background-color: #aaa;
      color: white;
      padding: 15px;
    }

    /* Set black background color, white text and some padding */
    header {
      background-color: #aaa;
      color: white;
      padding: 15px;
    }
    
    /* On small screens, set height to 'auto' for sidenav and grid */
    @media screen and (max-width: 767px) {
      .sidenav {
        height: auto;
        padding: 15px;
      }
      .row.content {height: auto;} 
    }

  .tab-pane{
    height:300px;
    overflow-y:scroll;
    width:100%;
    background-color: #bbb;
  }

  </style>

</head>
<body>
<header class="container-fluid" align="right">
  <p><img src="images/RedHat.png" width="100px"/></p>
</header>

<div class="container-fluid">
  <div class="row content">
    <div class="col-sm-12">

<%
    long start = System.currentTimeMillis();
    
    Map<String,String> envs = System.getenv();
    String[] sorted = new String[envs.keySet().size()];

    String configFileLocation = ( envs.get("configfilelocation") == null ? "NOENV" : envs.get("configfilelocation"));

    int pos = 0;
    for( String envName : envs.keySet())
    {
      sorted[pos] = envName;
      pos++;
    }
    
    Arrays.parallelSort(sorted);
    
    long end = System.currentTimeMillis();
%>    
      <h5><span class="glyphicon glyphicon-time"></span> Duration of page build <b><%= end - start %>ms.</b></h5>
      <div class="container tab-pane">
        <table class="table table-bordered">
        <thead>
          <tr>
            <th>ENV Name</th>
            <th>Env Value</th>
          </tr>
        </thead>
        <tbody>

<%    
    for( int loop = 0; loop < sorted.length; loop++ )
    {
%>
          <tr>
            <td align="right"><b><%= sorted[loop] %></b></td>
            <td><%= envs.get(sorted[loop]) %></td>
          </tr>
<%
    }
%>
        </tbody>
        </table>
      </div>
      <h5><span id="targeturl" class="label label-success">Using config file location <%= configFileLocation %></span></h5>
      <div class="container tab-pane">
<%
      if( "NOENV".equals( configFileLocation ) )
      {
%>
      <h5><span id="targeturl" class="label label-failure">No environment variable set (needs 'configFileLocation').</span></h5>
<%        
      }
      else
      {
 %>
      <b>
 <%     	
      	try
      	{
          BufferedReader br = null;

          br = new BufferedReader(new FileReader(configFileLocation));
            
          String line = null;

          while(( line = br.readLine() ) != null) 
          {
%>
       <%= line %><br/>
<%
          }

          br.close();
        }
      	catch( IOException exc )
      	{
%>
      <h5><span id="targeturl" class="label label-failure">IO Exception when trying to load <%= configFileLocation %>.</span></h5>
<%      		
      	}
      } 
%>
      </div>
    </div>
  </div>
</div>

<footer class="container-fluid">
  <p><img src="images/openshift.png" width="125px"/></p>
</footer>

</body> 
</html>
