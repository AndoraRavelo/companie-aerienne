<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<h1 class="mb-4">Réserver un vol</h1>

<div class="card mb-4">
  <div class="card-body">
    <h5 class="card-title">Vol programmé</h5>
    <p class="card-text">
      Date/heure : ${vp.dateHeure} <br/>
      Avion : <c:out value="${vp.avion.matricule}"/> <br/>
      Sièges restants : <strong>${restants}</strong>
    </p>
  </div>
</div>

<form class="needs-validation" method="post" action="/reservation/create">
  <input type="hidden" name="vpId" value="${vp.id}"/>
  <div class="mb-3">
    <label class="form-label">Client</label>
    <select name="clientId" class="form-select" required>
      <c:forEach items="${passagers}" var="p">
        <option value="${p.id}">${p.prenom} ${p.nom}</option>
      </c:forEach>
    </select>
  </div>
  <div class="mb-3">
    <label class="form-label">Classe</label>
    <select name="classeId" class="form-select" required>
      <c:forEach items="${classes}" var="c">
        <option value="${c.id}">${c.nom}</option>
      </c:forEach>
    </select>
  </div>
  <div class="mb-3">
    <label class="form-label">Nombre de places</label>
    <input type="number" name="nombrePlaces" class="form-control" min="1" max="${restants}" value="1" required>
  </div>
  <button type="submit" class="btn btn-primary">Confirmer</button>
  <a href="/volsprogrammations" class="btn btn-secondary">Annuler</a>
</form>
