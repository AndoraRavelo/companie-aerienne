<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
  <div>
    <h1 class="h3 mb-1 d-flex align-items-center gap-2">
      <i class="bi bi-bag-plus"></i>
      <span>Achat produits extra</span>
    </h1>
    <div class="text-muted">Sélectionne un vol programmé, puis un client, et saisis les quantités des produits.</div>
  </div>
</div>

<c:if test="${not empty error}">
  <div class="alert alert-danger" role="alert">
    <c:out value="${error}"/>
  </div>
</c:if>

<div class="card mb-3">
  <div class="card-body">
    <form class="row g-3 align-items-end" method="get" action="/extras/achats/new">
      <div class="col-12 col-lg-8">
        <label class="form-label text-muted">Vol programmé</label>
        <select class="form-select" name="vpId" required>
          <option value="" disabled ${empty vpId ? 'selected' : ''}>-- Choisir un vol --</option>
          <c:forEach items="${vpOptions}" var="o">
            <option value="${o.id()}" ${vpId == o.id() ? 'selected' : ''}><c:out value="${o.label()}"/></option>
          </c:forEach>
        </select>
      </div>
      <div class="col-12 col-lg-4">
        <button type="submit" class="btn btn-primary w-100">
          <i class="bi bi-search me-1"></i>
          Continuer
        </button>
      </div>
    </form>
  </div>
</div>

<c:if test="${not empty selectedVp}">
  <div class="card mb-3">
    <div class="card-body">
      <h5 class="card-title mb-3">Nouvel achat</h5>

      <form method="post" action="/extras/achats" class="row g-3">
        <input type="hidden" name="vpId" value="${selectedVp.id}"/>

        <div class="col-12 col-md-6">
          <label class="form-label text-muted">Client</label>
          <select class="form-select" name="clientId" required>
            <option value="" disabled selected>-- Choisir un client --</option>
            <c:forEach items="${clients}" var="c">
              <option value="${c.id}"><c:out value="${c.nom}"/> <c:out value="${c.prenom}"/></option>
            </c:forEach>
          </select>
        </div>

        <div class="col-12">
          <div class="table-responsive">
            <table class="table table-sm table-hover align-middle mb-0">
              <thead class="table-light">
              <tr>
                <th>Produit</th>
                <th class="text-end">Prix unitaire</th>
                <th style="width: 160px" class="text-end">Quantité</th>
              </tr>
              </thead>
              <tbody>
              <c:choose>
                <c:when test="${empty produits}">
                  <tr>
                    <td colspan="3" class="text-muted">Aucun produit extra actif.</td>
                  </tr>
                </c:when>
                <c:otherwise>
                  <c:forEach items="${produits}" var="p">
                    <tr>
                      <td>
                        <c:out value="${p.libelle}"/>
                        <input type="hidden" name="produitId" value="${p.id}"/>
                      </td>
                      <td class="text-end"><fmt:formatNumber value="${p.prixUnitaire}" type="number" groupingUsed="true" /> Ar</td>
                      <td class="text-end">
                        <input class="form-control form-control-sm text-end" type="number" name="quantite" min="0" value="0"/>
                      </td>
                    </tr>
                  </c:forEach>
                </c:otherwise>
              </c:choose>
              </tbody>
            </table>
          </div>
        </div>

        <div class="col-12 d-flex justify-content-end gap-2">
          <a class="btn btn-outline-secondary" href="/extras/achats/new?vpId=${selectedVp.id}">Réinitialiser</a>
          <button type="submit" class="btn btn-success">
            <i class="bi bi-check2-circle me-1"></i>
            Enregistrer l'achat
          </button>
        </div>
      </form>
    </div>
  </div>
</c:if>
