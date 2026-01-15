<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<h1 class="mb-4">Liste des avions</h1>

<!-- Barre de recherche simple -->
<form class="row g-3 mb-3" method="get" action="/avions">
  <div class="col-auto">
    <input type="text" class="form-control" name="matricule" placeholder="Matricule" value="${param.matricule}">
  </div>
  <div class="col-auto">
    <button type="submit" class="btn btn-primary">Filtrer</button>
  </div>
</form>

<table class="table table-striped table-hover">
  <thead>
  <tr>
    <th>ID</th>
    <th>Matricule</th>
    <th>Capacité</th>
  </tr>
  </thead>
  <tbody>
  <c:forEach items="${avions}" var="a">
    <tr>
      <td>${a.id}</td>
      <td>${a.matricule}</td>
      <td>${a.capacite}</td>
    </tr>
  </c:forEach>
  </tbody>
</table>
