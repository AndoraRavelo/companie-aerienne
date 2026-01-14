<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<h1 class="mb-4">Vols programmés</h1>

<table class="table table-hover table-bordered align-middle">
  <thead class="table-light">
  <tr>
    <th>ID</th>
    <th>Route</th>
    <th>Date/heure</th>
    <th>Avion</th>
    <th>Capacité</th>
    <th>Réservés</th>
    <th>Restants</th>
    <th></th>
  </tr>
  </thead>
  <tbody>
  <c:forEach items="${volsInfos}" var="info">
    <tr>
      <td>${info.vp.id}</td>
      <td>${info.vp.vol.aeroportDepart.nom} → ${info.vp.vol.aeroportArrivee.nom}</td>
      <td>${info.vp.dateHeure}</td>
      <td>${info.vp.avion.matricule}</td>
      <td>${info.capacite}</td>
      <td>${info.siegesReserves}</td>
      <td>${info.restants()}</td>
      <td>
        <c:choose>
          <c:when test="${info.restants() > 0}">
            <a class="btn btn-sm btn-primary" href="/reservation/new?vpId=${info.vp.id}">Réserver</a>
          </c:when>
          <c:otherwise>
            <span class="badge bg-secondary">Complet</span>
          </c:otherwise>
        </c:choose>
      </td>
    </tr>
  </c:forEach>
  <c:if test="${empty volsInfos}">
    <tr><td colspan="8" class="text-center text-muted">Aucune programmation disponible.</td></tr>
  </c:if>
  </tbody>
</table>
