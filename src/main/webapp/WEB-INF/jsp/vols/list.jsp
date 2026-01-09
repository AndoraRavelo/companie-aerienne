<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<h1 class="mb-4">Liste des vols</h1>

<table class="table table-striped table-hover">
  <thead>
  <tr>
    <th>ID</th>
    <th>Code vol</th>
    <th>Départ</th>
    <th>Arrivée</th>
    <th>Date départ</th>
    <th>Statut</th>
  </tr>
  </thead>
  <tbody>
  <c:forEach items="${vols}" var="v">
    <tr>
      <td>${v.id}</td>
      <td>${v.codeVol}</td>
      <td>${v.aeroportDepart != null ? v.aeroportDepart.codeIata : ''}</td>
      <td>${v.aeroportArrivee != null ? v.aeroportArrivee.codeIata : ''}</td>
      <td>${v.dateHeureDepart}</td>
      <td>${v.statut}</td>
    </tr>
  </c:forEach>
  </tbody>
</table>
