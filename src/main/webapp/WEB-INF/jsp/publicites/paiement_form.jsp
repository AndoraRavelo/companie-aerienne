<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
  <div>
    <h1 class="h3 mb-1 d-flex align-items-center gap-2">
      <i class="bi bi-cash-coin"></i>
      <span>Paiement publicité</span>
    </h1>
    <div class="text-muted">Enregistrer un paiement reçu d'une société pour les publicités.</div>
  </div>
</div>

<c:if test="${not empty error}">
  <div class="alert alert-danger" role="alert">
    <c:out value="${error}"/>
  </div>
</c:if>

<c:if test="${not empty success}">
  <div class="alert alert-success" role="alert">
    <c:out value="${success}"/>
  </div>
</c:if>

<div class="card">
  <div class="card-body">
    <form class="row g-3" method="post" action="/publicites/paiements/create">

      <div class="col-12 col-md-6">
        <label class="form-label text-muted">Société</label>
        <select class="form-select" name="societeId" required>
          <option value="" disabled ${empty societeId ? 'selected' : ''}>-- Choisir une société --</option>
          <c:forEach items="${societes}" var="s">
            <option value="${s.id}" ${societeId == s.id ? 'selected' : ''}>
              <c:out value="${s.nom}"/>
            </option>
          </c:forEach>
        </select>
      </div>

      <div class="col-12 col-md-3">
        <label class="form-label text-muted">Année</label>
        <input type="number" name="annee" class="form-control" value="${annee}" min="2000" max="2100" required />
      </div>

      <div class="col-12 col-md-3">
        <label class="form-label text-muted">Mois</label>
        <input type="number" name="mois" class="form-control" value="${mois}" min="1" max="12" required />
      </div>

      <div class="col-12 col-md-3">
        <label class="form-label text-muted">Date de paiement</label>
        <input type="date" class="form-control" name="datePaiement" value="${datePaiement}" required />
      </div>

      <div class="col-12 col-md-3">
        <label class="form-label text-muted">Montant (Ar)</label>
        <input type="number" class="form-control" name="montant" value="${montant}" min="0" step="0.01" required />
      </div>

      <div class="col-12 d-flex gap-2">
        <button type="submit" class="btn btn-primary">
          <i class="bi bi-save me-1"></i>
          Enregistrer
        </button>
        <a class="btn btn-outline-secondary" href="/publicites/ca">
          <i class="bi bi-arrow-left me-1"></i>
          Retour
        </a>
      </div>

    </form>
  </div>
</div>
