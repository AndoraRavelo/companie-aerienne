<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<h1 class="mb-4">Réserver un vol</h1>

<div class="card mb-4">
  <div class="card-body">
    <h5 class="card-title">Vol ${vp.trajet.codeTrajet}</h5>
    <p class="card-text">
      Départ : ${vp.departTs} <br/>
      Arrivée : ${vp.arriveeTs} <br/>
      Sièges restants : <strong>${restants}</strong>
    </p>
  </div>
</div>

<form class="needs-validation" method="post" action="/reservation/create">
  <input type="hidden" name="vpId" value="${vp.id}"/>
  <div class="mb-3">
    <label class="form-label">Passager</label>
    <select name="passagerId" class="form-select" required>
      <c:forEach items="${passagers}" var="p">
        <option value="${p.id}">${p.prenom} ${p.nom}</option>
      </c:forEach>
    </select>
  </div>
  <div class="mb-3">
    <label class="form-label">Nombre de sièges</label>
    <input type="number" name="sieges" class="form-control" min="1" max="${restants}" value="1" required>
  </div>
  <button type="submit" class="btn btn-primary">Confirmer</button>
  <a href="/volsprogrammes" class="btn btn-secondary">Annuler</a>
</form>
