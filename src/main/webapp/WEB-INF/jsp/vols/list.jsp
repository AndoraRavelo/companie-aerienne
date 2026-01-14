<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<h1 class="mb-4">Liste des vols</h1>

<table class="table table-striped table-hover">
  <thead>
  <tr>
    <th>ID</th>
    <th>Départ</th>
    <th>Arrivée</th>
    <th>Durée (h)</th>
  </tr>
  </thead>
  <tbody>
  <c:forEach items="${vols}" var="v">
    <tr>
      <td>${v.id}</td>
      <td>${v.aeroportDepart != null ? v.aeroportDepart.nom : ''}</td>
      <td>${v.aeroportArrivee != null ? v.aeroportArrivee.nom : ''}</td>
      <td>${v.duree}</td>
    </tr>
  </c:forEach>
  </tbody>
</table>
