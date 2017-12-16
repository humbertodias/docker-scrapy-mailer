<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="ie=edge"/>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous"/>
</head>
<body>

<div class="alert alert-info">Banco de Talentos SENAC - ${now}</div>

<table class="table table-hover">
    <thead>
    <tr>
        <th scope="col">Codigo</th>
        <th scope="col">Cargo</th>
        <th scope="col">Vagas</th>
    </tr>
	</thead>
    % for vaga in vagas:
    <tbody>
    <tr scope="row">
        <td>${vaga['codigo']}</td>\
        <td><a href="${vaga['href']}" target="_blank">${vaga['cargo']}</a></td>\
        <td>${vaga['vagas']}</td>\
    </tr>
	</tbody>
    % endfor
  <tfoot>
    <tr>
      <th colspan="3" style="text-align: center">Total: ${len(vagas)}</th>
    </tr>
  </tfoot>
</table>

</body>
</html>