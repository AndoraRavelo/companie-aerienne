<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<h1 class="mb-4">Réservations</h1>

<!-- Filtre Vol programme -->
<form class="row g-3 mb-3" method="get" action="/reservations">
  <div class="col-auto">
    <select name="vpId" class="form-select" required>
      <option value="">-- Choisir un vol --</option>
      <c:forEach items="${vols}" var="v">
        <option value="${v.id}" ${selectedVp != null && selectedVp.id == v.id ? 'selected' : ''}>
          ${v.trajet.codeTrajet} | ${v.departTs}
        </option>
      </c:forEach>
    </select>
  </div>
  <div class="col-auto">
    <button type="submit" class="btn btn-primary">Afficher</button>
  </div>
</form>

<c:if test="${selectedVp != null}">
  <h5>Vol : ${selectedVp.trajet.codeTrajet} – ${selectedVp.departTs}</h5>

  <table class="table table-bordered table-hover mt-3">
    <thead class="table-light">
    <tr>
      <th>Code</th>
      <th>Passager</th>
      <th>Sièges</th>
      <th>Prix</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${reservations}" var="r">
      <tr>
        <td>${r.codeResa}</td>
        <td>${r.passager.prenom} ${r.passager.nom}</td>
        <td>${r.sieges}</td>
        <td><fmt:formatNumber value="${r.prix}" type="currency" currencySymbol="Ar"/></td>
      </tr>
    </c:forEach>
    <c:if test="${empty reservations}">
      <tr><td colspan="4" class="text-center text-muted">Aucune réservation pour ce vol.</td></tr>
    </c:if>
    </tbody>
  </table>

  <div class="alert alert-info">
    Recette totale : <strong><fmt:formatNumber value="${total}" type="currency" currencySymbol="Ar"/></strong>
  </div>
</c:if>
