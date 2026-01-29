<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
  <div>
    <h1 class="h3 mb-1 d-flex align-items-center gap-2">
      <i class="bi bi-graph-up"></i>
      <span>Chiffre d'affaire</span>
    </h1>
    <div class="text-muted">Sélectionne une destination pour afficher le chiffre d'affaire par vol programmé.</div>
  </div>
</div>

<c:if test="${not empty error}">
  <div class="alert alert-danger" role="alert">
    <c:out value="${error}"/>
  </div>
</c:if>

<div class="card mb-3">
  <div class="card-body">
    <form class="row g-3 align-items-end" method="get" action="/chiffre-affaire">
      <div class="col-12 col-md-4">
        <label class="form-label text-muted">Aéroport départ</label>
        <select class="form-select" name="depart" required>
          <option value="" disabled ${empty depart ? 'selected' : ''}>-- Choisir --</option>
          <c:forEach items="${aeroports}" var="a">
            <option value="${a.nom}" ${depart == a.nom ? 'selected' : ''}><c:out value="${a.nom}"/></option>
          </c:forEach>
        </select>
      </div>
      <div class="col-12 col-md-4">
        <label class="form-label text-muted">Aéroport arrivée</label>
        <select class="form-select" name="arrivee" required>
          <option value="" disabled ${empty arrivee ? 'selected' : ''}>-- Choisir --</option>
          <c:forEach items="${aeroports}" var="a">
            <option value="${a.nom}" ${arrivee == a.nom ? 'selected' : ''}><c:out value="${a.nom}"/></option>
          </c:forEach>
        </select>
      </div>
      <div class="col-12 col-md-4 d-flex gap-2">
        <button type="submit" class="btn btn-primary">
          <i class="bi bi-search me-1"></i>
          Afficher
        </button>
      </div>
    </form>
  </div>
</div>

<c:if test="${not empty lignes}">
  <div class="card mb-3">
    <div class="card-body">
      <h5 class="card-title mb-3">Détail</h5>

      <div class="row g-2 mb-3">
        <div class="col-12 col-md-4">
          <div class="border border-primary-subtle bg-primary-subtle rounded-3 p-3 h-100 shadow-sm">
            <div class="d-flex align-items-center justify-content-between">
              <div class="text-primary fw-semibold">CA THEORIQUE</div>
              <i class="bi bi-graph-up-arrow text-primary"></i>
            </div>
            <div class="mt-1 fs-4 fw-bold text-primary-emphasis">
              <fmt:formatNumber value="${caTheorique}" type="number" groupingUsed="true" /> Ar
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
              <fmt:formatNumber value="${caPaye}" type="number" groupingUsed="true" /> Ar
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
              <fmt:formatNumber value="${resteAPayer}" type="number" groupingUsed="true" /> Ar
            </div>
            <div class="small text-danger-emphasis">Solde dû</div>
          </div>
        </div>
      </div>

      <div class="row g-2 mb-3 justify-content-center">
        <div class="col-12 col-md-3">
          <div class="border border-secondary-subtle bg-body-tertiary rounded-3 p-2 h-100 shadow-sm">
            <div class="d-flex align-items-center justify-content-between">
              <div class="text-muted fw-semibold small text-uppercase">CA Billets</div>
              <i class="bi bi-ticket-perforated text-muted"></i>
            </div>
            <div class="mt-1 fs-6 fw-bold text-body">
              <fmt:formatNumber value="${caBilletsTotal}" type="number" groupingUsed="true" /> Ar
            </div>
            <div class="small text-muted">Recette billets sur la période</div>
          </div>
        </div>
        <div class="col-12 col-md-3">
          <div class="border border-secondary-subtle bg-body-tertiary rounded-3 p-2 h-100 shadow-sm">
            <div class="d-flex align-items-center justify-content-between">
              <div class="text-muted fw-semibold small text-uppercase">CA Diffusions</div>
              <i class="bi bi-megaphone text-muted"></i>
            </div>
            <div class="mt-1 fs-6 fw-bold text-body">
              <fmt:formatNumber value="${caDiffusionsTheorique}" type="number" groupingUsed="true" /> Ar
            </div>
            <div class="small text-muted">Montant des pubs diffusées</div>
          </div>
        </div>
        <div class="col-12 col-md-3">
          <div class="border border-secondary-subtle bg-body-tertiary rounded-3 p-2 h-100 shadow-sm">
            <div class="d-flex align-items-center justify-content-between">
              <div class="text-muted fw-semibold small text-uppercase">CA Extras</div>
              <i class="bi bi-bag-plus text-muted"></i>
            </div>
            <div class="mt-1 fs-6 fw-bold text-body">
              <fmt:formatNumber value="${caExtrasTotal}" type="number" groupingUsed="true" /> Ar
            </div>
            <div class="small text-muted">Ventes extras sur la période</div>
          </div>
        </div>
      </div>

      <c:if test="${not empty periodeStart and not empty periodeEnd}">
        <div class="mt-2 text-muted">Période : ${periodeStart} → ${periodeEnd}</div>
      </c:if>
    </div>
  </div>

  <div class="card mb-3">
    <div class="card-body">
      <h5 class="card-title mb-3">Paiements reçus (publicités)</h5>
      <div class="table-responsive">
        <table class="table table-sm align-middle mb-0">
          <thead class="table-light">
          <tr>
            <th>Société</th>
            <th class="text-end">Montant</th>
          </tr>
          </thead>
          <tbody>
          <c:choose>
            <c:when test="${empty paiementsPubs}">
              <tr>
                <td colspan="2" class="text-muted">Aucun paiement enregistré sur la période.</td>
              </tr>
            </c:when>
            <c:otherwise>
              <c:forEach items="${paiementsPubs}" var="p">
                <tr>
                  <td><c:out value="${p.societe()}"/></td>
                  <td class="text-end"><fmt:formatNumber value="${p.montant()}" type="number" groupingUsed="true" /> Ar</td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</c:if>

<c:if test="${not empty lignes}">
  <div class="card mb-3">
    <div class="card-body">
      <h5 class="card-title mb-3">Chiffre d'affaire par vol programmé</h5>
      <div class="table-responsive">
        <table class="table table-sm table-hover align-middle mb-0">
          <thead class="table-light">
          <tr>
            <th>Route</th>
            <th>Avion</th>
            <th>Départ</th>
            <th class="text-end">Billets vendus</th>
            <th class="text-end">CA billets</th>
            <th class="text-end">Diffusions pubs</th>
            <th class="text-end">CA pubs</th>
            <th class="text-end">CA extras</th>
            <th class="text-end">Total payé pubs</th>
            <th class="text-end">Reste à payer pubs</th>
            <th class="text-end">CA total</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach items="${lignes}" var="l">
            <tr>
              <td>
                <div class="fw-semibold"><c:out value="${l.vp.vol.aeroportDepart.nom}"/> → <c:out value="${l.vp.vol.aeroportArrivee.nom}"/></div>
              </td>
              <td><c:out value="${l.vp.avion.matricule}"/></td>
              <td>
                <div class="fw-semibold"><c:out value="${l.dateDepart}"/></div>
                <div class="text-muted small"><c:out value="${l.heureDepart}"/></div>
              </td>
              <td class="text-end"><c:out value="${l.billetsVendus}"/></td>
              <td class="text-end"><fmt:formatNumber value="${l.montantBillets}" type="number" groupingUsed="true" /> Ar</td>
              <td class="text-end"><c:out value="${l.diffusions}"/></td>
              <td class="text-end"><fmt:formatNumber value="${l.montantPublicites}" type="number" groupingUsed="true" /> Ar</td>
              <td class="text-end"><fmt:formatNumber value="${l.montantExtras}" type="number" groupingUsed="true" /> Ar</td>
              <c:choose>
                <c:when test="${l.montantPublicitesPayee > 0}">
                  <td class="text-end text-success fw-semibold"><fmt:formatNumber value="${l.montantPublicitesPayee}" type="number" groupingUsed="true" /> Ar</td>
                </c:when>
                <c:otherwise>
                  <td class="text-end text-success fw-semibold"><fmt:formatNumber value="${l.montantPublicitesPayee}" type="number" groupingUsed="true" /> Ar</td>
                </c:otherwise>
              </c:choose>
              <c:choose>
                <c:when test="${l.restePublicites > 0}">
                  <td class="text-end text-danger fw-semibold"><fmt:formatNumber value="${l.restePublicites}" type="number" groupingUsed="true" /> Ar</td>
                </c:when>
                <c:otherwise>
                  <td class="text-end text-muted"><fmt:formatNumber value="${l.restePublicites}" type="number" groupingUsed="true" /> Ar</td>
                </c:otherwise>
              </c:choose>
              <td class="text-end text-primary fw-semibold"><fmt:formatNumber value="${l.montantTotal}" type="number" groupingUsed="true" /> Ar</td>
            </tr>
          </c:forEach>
          </tbody>
          <c:if test="${not empty totauxTable}">
            <tfoot class="table-light">
            <tr class="fw-bold">
              <th colspan="3" class="text-end">TOTAL</th>
              <th class="text-end"><c:out value="${totauxTable.billetsVendus}"/></th>
              <th class="text-end"><fmt:formatNumber value="${totauxTable.caBillets}" type="number" groupingUsed="true" /> Ar</th>
              <th class="text-end"><c:out value="${totauxTable.diffusionsPubs}"/></th>
              <th class="text-end"><fmt:formatNumber value="${totauxTable.caPubs}" type="number" groupingUsed="true" /> Ar</th>
              <th class="text-end"><fmt:formatNumber value="${totauxTable.caExtras}" type="number" groupingUsed="true" /> Ar</th>
              <th class="text-end"><fmt:formatNumber value="${totauxTable.pubsPayees}" type="number" groupingUsed="true" /> Ar</th>
              <th class="text-end"><fmt:formatNumber value="${totauxTable.restePubs}" type="number" groupingUsed="true" /> Ar</th>
              <th class="text-end"><fmt:formatNumber value="${totauxTable.caTotal}" type="number" groupingUsed="true" /> Ar</th>
            </tr>
            </tfoot>
          </c:if>
        </table>
      </div>
    </div>
  </div>
</c:if>

<c:if test="${empty lignes and not empty depart and not empty arrivee and empty error}">
  <div class="alert alert-warning" role="alert">
    Aucun vol programmé trouvé pour cette destination.
  </div>
</c:if>
