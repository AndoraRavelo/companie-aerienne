<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<h1 class="mb-4">Liste des equipages</h1>

<table class="table table-striped table-hover">
  <thead>
  <tr>
    <th>ID</th>
    <th>Nom complet</th>
    <th>Role</th>
    <th>Heures de vol</th>
  </tr>
  </thead>
  <tbody>
  <c:forEach items="${equipages}" var="e">
    <tr>
      <td>${e.id}</td>
      <td>${e.nomComplet}</td>
      <td>${e.role}</td>
      <td>${e.heuresVol}</td>
    </tr>
  </c:forEach>
  </tbody>
</table>
