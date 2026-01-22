<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
  <div>
    <h1 class="h3 mb-1 d-flex align-items-center gap-2">
      <i class="bi bi-megaphone"></i>
      <span>Chiffre d'affaires - Publicités</span>
    </h1>
    <div class="text-muted">Sélectionne un mois pour calculer le chiffre d'affaires issu des diffusions publicitaires.</div>
  </div>
</div>

<div class="card mb-3">
  <div class="card-body">
    <form class="row g-3 align-items-end" method="get" action="/publicites/ca">
      <div class="col-12 col-md-3">
        <label class="form-label text-muted">Année</label>
        <input type="number" name="annee" class="form-control" value="${annee}" min="2000" max="2100" required />
      </div>
      <div class="col-12 col-md-3">
        <label class="form-label text-muted">Mois</label>
        <input type="number" name="mois" class="form-control" value="${mois}" min="1" max="12" required />
      </div>
      <div class="col-12 col-md-6 d-flex gap-2">
        <button type="submit" class="btn btn-primary">
          <i class="bi bi-calculator me-1"></i>
          Calculer
        </button>
      </div>
    </form>
  </div>
</div>

<c:if test="${not empty error}">
  <div class="alert alert-danger" role="alert">
    <c:out value="${error}"/>
  </div>
</c:if>

<c:if test="${not empty ca}">
  <div class="card mb-3">
    <div class="card-body">
      <h5 class="card-title mb-3">Détail des diffusions</h5>

      <div class="row g-2 mb-3">
        <div class="col-12 col-md-4">
          <div class="border border-primary-subtle bg-primary-subtle rounded-3 p-3 h-100 shadow-sm">
            <div class="d-flex align-items-center justify-content-between">
              <div class="text-primary fw-semibold">CA THEORIQUE</div>
              <i class="bi bi-graph-up-arrow text-primary"></i>
            </div>
            <div class="mt-1 fs-4 fw-bold text-primary-emphasis">
              <fmt:formatNumber value="${rapport.total()}" type="number" groupingUsed="true" /> Ar
            </div>
            <div class="small text-primary-emphasis">Total facturé sur la période</div>
          </div>
        </div>
        <div class="col-12 col-md-4">
          <div class="border border-success-subtle bg-success-subtle rounded-3 p-3 h-100 shadow-sm">
            <div class="d-flex align-items-center justify-content-between">
              <div class="text-success fw-semibold">CA ACTUELLE (PAYE)</div>
              <i class="bi bi-check-circle text-success"></i>
            </div>
            <div class="mt-1 fs-4 fw-bold text-success-emphasis">
              <fmt:formatNumber value="${rapport.totalPaye()}" type="number" groupingUsed="true" /> Ar
            </div>
            <div class="small text-success-emphasis">Paiements reçus</div>
          </div>
        </div>
        <div class="col-12 col-md-4">
          <div class="border border-danger-subtle bg-danger-subtle rounded-3 p-3 h-100 shadow-sm">
            <div class="d-flex align-items-center justify-content-between">
              <div class="text-danger fw-semibold">Reste à payer</div>
              <i class="bi bi-exclamation-triangle text-danger"></i>
            </div>
            <div class="mt-1 fs-4 fw-bold text-danger-emphasis">
              <fmt:formatNumber value="${rapport.totalReste()}" type="number" groupingUsed="true" /> Ar
            </div>
            <div class="small text-danger-emphasis">Solde dû</div>
          </div>
        </div>
      </div>

      <div class="table-responsive">
        <table class="table table-sm align-middle mb-0">
          <thead class="table-light">
            <tr>
              <th>Société</th>
              <th class="text-end">Diffusions</th>
              <th class="text-end">Prix unitaire</th>
              <th class="text-end">Montant</th>
              <th class="text-end">Payé</th>
              <th class="text-end">Reste</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${empty lignes}">
                <tr>
                  <td colspan="6" class="text-muted">Aucune diffusion sur cette période.</td>
                </tr>
              </c:when>
              <c:otherwise>
                <c:forEach items="${lignes}" var="l">
                  <tr>
                    <td><c:out value="${l.societe()}"/></td>
                    <td class="text-end"><c:out value="${l.nombreDiffusions()}"/></td>
                    <td class="text-end">
                      <fmt:formatNumber value="${l.prixUnitaire()}" type="number" groupingUsed="true" /> Ar
                    </td>
                    <td class="text-end">
                      <fmt:formatNumber value="${l.montant()}" type="number" groupingUsed="true" /> Ar
                    </td>
                    <td class="text-end">
                      <fmt:formatNumber value="${l.montantPaye()}" type="number" groupingUsed="true" /> Ar
                    </td>
                    <td class="text-end">
                      <fmt:formatNumber value="${l.resteAPayer()}" type="number" groupingUsed="true" /> Ar
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
          <tfoot>
            <tr>
              <th colspan="3" class="text-end">Total CA</th>
              <th class="text-end"><fmt:formatNumber value="${rapport.total()}" type="number" groupingUsed="true" /> Ar</th>
              <th class="text-end">-</th>
              <th class="text-end">-</th>
            </tr>
            <tr>
              <th colspan="4" class="text-end">Total payé</th>
              <th class="text-end"><fmt:formatNumber value="${rapport.totalPaye()}" type="number" groupingUsed="true" /> Ar</th>
              <th class="text-end">-</th>
            </tr>
            <tr>
              <th colspan="5" class="text-end">Total reste à payer</th>
              <th class="text-end"><fmt:formatNumber value="${rapport.totalReste()}" type="number" groupingUsed="true" /> Ar</th>
            </tr>
          </tfoot>
        </table>
      </div>

      <div class="mt-2 text-muted">Période : ${mois}/${annee}</div>
    </div>
  </div>
</c:if>
