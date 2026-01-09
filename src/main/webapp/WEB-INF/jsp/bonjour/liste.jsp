<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.companieaerienne.entities.Bonjour" %>
<% List<Bonjour> liste = (List<Bonjour>) request.getAttribute("bonjours"); %>
<html>
<head>
    <title>Liste Bonjour</title>
</head>
<body>

<h2>Liste des messages Bonjour</h2>

<table border="1" cellpadding="5">
    <tr>
        <th>ID</th>
        <th>Message</th>
    </tr>
    <%
            for(Bonjour b : liste){
    %>
    <tr>
        <td><%= b.getId() %></td>
        <td><%= b.getMessage() %></td>
    </tr>
    <%
        }
    %>
</table>
</body>
</html>
