<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<h1 class="mb-4">Reservations</h1>

<!-- Filtre Vol programmé -->
<form class="row g-3 mb-3" method="get" action="/reservations">
  <div class="col-auto">
    <select name="vpId" class="form-select" required>
      <option value="">-- Choisir un vol programmé --</option>
      <c:forEach items="${vols}" var="v">
        <option value="${v.id}" ${selectedVp != null && selectedVp.id == v.id ? 'selected' : ''}>
          ${v.vol.aeroportDepart.nom} → ${v.vol.aeroportArrivee.nom} | ${v.dateHeure}
        </option>
      </c:forEach>
    </select>
  </div>
  <div class="col-auto">
    <button type="submit" class="btn btn-primary">Afficher</button>
  </div>
</form>

<c:if test="${selectedVp != null}">
  <h5>Vol programme : ${selectedVp.vol.aeroportDepart.nom} -> ${selectedVp.vol.aeroportArrivee.nom} - ${selectedVp.dateHeure}</h5>

  <table class="table table-bordered table-hover mt-3">
    <thead class="table-light">
    <tr>
      <th>Client</th>
      <th>Nombre de places</th>
      <th>Details des places</th>
      <th>Sous-total</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${reservations}" var="r">
      <tr>
        <td>${r.client.prenom} ${r.client.nom}</td>
        <td>${r.nombrePlaces}</td>
        <td>
          <c:if test="${not empty details[r.id]}">
            <ul class="mb-0">
              <c:forEach items="${details[r.id]}" var="line">
                <li><c:out value="${line}"/></li>
              </c:forEach>
            </ul>
          </c:if>
        </td>
        <td>
          <c:if test="${not empty subtotals[r.id]}">
            <fmt:formatNumber value="${subtotals[r.id]}" type="currency" currencySymbol="Ar"/>
          </c:if>
        </td>
      </tr>
    </c:forEach>
    <c:if test="${empty reservations}">
      <tr><td colspan="4" class="text-center text-muted">Aucune reservation pour ce vol.</td></tr>
    </c:if>
    </tbody>
  </table>

  <div class="alert alert-info">
    Recette totale : <strong><fmt:formatNumber value="${total}" type="currency" currencySymbol="Ar"/></strong>
  </div>
</c:if>
