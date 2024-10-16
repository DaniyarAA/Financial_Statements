<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Удаление компании</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4">Удалить компанию</h2>

    <form action="/company/delete" method="post">
        <#if _csrf??>
            <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                   value="${(_csrf.token)!'csrf-token'}"/>
        </#if>
        <div class="input-group mb-3">
            <span class="input-group-text" id="categories">Выберите компанию для удаления</span>
            <select class="form-select" aria-label="companyId" name="companyId" required>
                <option value="" disabled selected>Нажмите чтобы открыть</option>
                <#list list as company>
                    <option value="${company.id}">${company.name}</option>
                </#list>
            </select>
        </div>
        <div class="d-flex justify-content-between">
            <button type="submit" class="btn btn-danger">Удалить</button>
        </div>
    </form>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
