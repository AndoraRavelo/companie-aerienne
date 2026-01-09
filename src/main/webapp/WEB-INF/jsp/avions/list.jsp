<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<h1 class="mb-4">Liste des avions</h1>

<!-- Barre de recherche simple -->
<form class="row g-3 mb-3" method="get" action="/avions">
  <div class="col-auto">
    <input type="text" class="form-control" name="immatriculation" placeholder="Immatriculation" value="${param.immatriculation}">
  </div>
  <div class="col-auto">
    <select class="form-select" name="statut">
      <option value="">Tous statuts</option>
      <option value="operationnel" ${param.statut == 'operationnel' ? 'selected' : ''}>Opérationnel</option>
      <option value="maintenance"  ${param.statut == 'maintenance'  ? 'selected' : ''}>Maintenance</option>
    </select>
  </div>
  <div class="col-auto">
    <button type="submit" class="btn btn-primary">Filtrer</button>
  </div>
</form>

<table class="table table-striped table-hover">
  <thead>
  <tr>
    <th>ID</th>
    <th>Immatriculation</th>
    <th>Modèle</th>
    <th>Capacité</th>
    <th>Statut</th>
  </tr>
  </thead>
  <tbody>
  <c:forEach items="${avions}" var="a">
    <tr>
      <td>${a.id}</td>
      <td>${a.immatriculation}</td>
      <td>${a.modele}</td>
      <td>${a.capacite}</td>
      <td>${a.statut}</td>
    </tr>
  </c:forEach>
  </tbody>
</table>
