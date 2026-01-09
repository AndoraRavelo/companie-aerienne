<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<h1 class="mb-4">Vols programmés</h1>

<!-- Barre de filtre Trajet -->
<form class="row g-3 mb-3" method="get" action="/volsprogrammes">
  <div class="col-auto">
    <select name="trajetId" class="form-select">
      <option value="">Tous trajets</option>
      <c:forEach items="${trajets}" var="t">
        <option value="${t.id}" ${param.trajetId == t.id ? 'selected' : ''}>${t.codeTrajet}</option>
      </c:forEach>
    </select>
  </div>
  <div class="col-auto">
    <button type="submit" class="btn btn-primary">Filtrer</button>
  </div>
</form>

<table class="table table-hover table-bordered align-middle">
  <thead class="table-light">
  <tr>
    <th>ID</th>
    <th>Trajet</th>
    <th>Départ</th>
    <th>Arrivée</th>
    <th>Capacité</th>
    <th>Réservés</th>
    <th>Restants</th>
    <th></th>
  </tr>
  </thead>
  <tbody>
  <c:forEach items="${volsInfos}" var="info">
    <tr>
      <td>${info.volProgramme.id}</td>
      <td>${info.volProgramme.trajet.codeTrajet}</td>
      <td>${info.volProgramme.departTs}</td>
      <td>${info.volProgramme.arriveeTs}</td>
      <td>${info.capacite}</td>
      <td>${info.siegesReserves}</td>
      <td>${info.siegesRestants()}</td>
      <td>
        <c:choose>
          <c:when test="${info.siegesRestants() > 0}">
            <a class="btn btn-sm btn-primary" href="/reservation/new?vpId=${info.volProgramme.id}">Réserver</a>
          </c:when>
          <c:otherwise>
            <span class="badge bg-secondary">Complet</span>
          </c:otherwise>
        </c:choose>
      </td>
    </tr>
  </c:forEach>
  </tbody>
</table>
