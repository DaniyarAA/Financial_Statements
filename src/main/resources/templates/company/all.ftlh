<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Список Компаний</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<header>


</header>
<div class="container">
    <div class="row">
            <div class="col-md-3">
                <div class="list-group">
                    <a href="/company/all/?companyId=0&page=0" class="list-group-item list-group-item-action <#if companyId == 0>active</#if>">Название</a>
                    <#list list as item>
                        <a href="/company/all/?companyId=${item.id}&page=${currentPage}" class="list-group-item list-group-item-action <#if companyId == item.id>active</#if>">${item.name}</a>
                    </#list>
                </div>
                <div class="mt-3">
                    <#if 0 < currentPage>
                        <a href="/company/all/?companyId=${companyId}&page=${currentPage - 1}" class="btn btn-secondary">Назад</a>
                    </#if>
                    <#if currentPage < totalPages - 1>
                        <a href="/company/all/?companyId=${companyId}&page=${currentPage + 1}" class="btn btn-secondary">Вперёд</a>
                    </#if>
                </div>
            </div>

        <div class="col-md-9">
            <#if company?? && company.id?has_content>
                <h2 class="mt-3 mb-3 text-center">Наименование компании: ${company.name!}</h2>
                <div class="row">
                    <div class="col-md-6">
                        <ul class="list-group">
                            <li class="list-group-item"><strong>ИНН:</strong> ${company.inn!}</li>
                            <li class="list-group-item"><strong>ИНН руководителя:</strong> ${company.directorInn!}</li>
                            <li class="list-group-item"><strong>Логин:</strong> ${company.login!}</li>
                            <li class="list-group-item"><strong>Пароль:</strong> ${company.password!}</li>
                            <li class="list-group-item"><strong>ЭЦП:</strong> ${company.ecp!}</li>
                            <li class="list-group-item"><strong>Salyk.kg логин:</strong> ${company.kabinetSalyk!}</li>
                            <li class="list-group-item"><strong>Salyk.kg пароль:</strong> ${company.kabinetSalykPassword!}</li>
                            <li class="list-group-item"><strong>Режим налогооблажения:</strong> ${company.taxMode!}</li>
                            <li class="list-group-item"><strong>ОПФ:</strong> ${company.opf!}</li>
                            <li class="list-group-item"><strong>Район ГНС:</strong> ${company.districtGns!}</li>
                            <li class="list-group-item"><strong>Номер социального фонда:</strong> ${company.socfundNumber!}</li>
                            <li class="list-group-item"><strong>Регистрационный номер МЮ:</strong> ${company.registrationNumberMj!}</li>
                            <li class="list-group-item"><strong>ОКПО:</strong> ${company.okpo!}</li>
                            <li class="list-group-item"><strong>ФИО руководителя:</strong> ${company.director!}</li>
                            <li class="list-group-item"><strong>КЭД:</strong> ${company.ked!}</li>
                        </ul>
                    </div>
                    <div class="col-md-6">
                        <ul class="list-group">
                            <li class="list-group-item"><strong>Почта:</strong> ${company.email!}</li>
                            <li class="list-group-item"><strong>Пароль от почты:</strong> ${company.emailPassword!}</li>
                            <li class="list-group-item"><strong>Телефон:</strong> ${company.phone!}</li>
                            <li class="list-group-item"><strong>ЭСФ логин:</strong> ${company.esf!}</li>
                            <li class="list-group-item"><strong>ЭСФ пароль:</strong> ${company.esfPassword!}</li>
                            <li class="list-group-item"><strong>ККМ логин:</strong> ${company.kkm!}</li>
                            <li class="list-group-item"><strong>ККМ пароль:</strong> ${company.kkmPassword!}</li>
                            <li class="list-group-item"><strong>1С Фреш логин:</strong> ${company.fresh1c!}</li>
                            <li class="list-group-item"><strong>1С Фреш пароль:</strong> ${company.fresh1cPassword!}</li>
                            <li class="list-group-item"><strong>ЭТТН логин:</strong> ${company.ettn!}</li>
                            <li class="list-group-item"><strong>ЭТТН пароль:</strong> ${company.ettnPassword!}</li>
                        </ul>
                    </div>
                </div>
            <#else>
                <p class="text-muted mt-3">Выберите компанию для отображения подробной информации.</p>
            </#if>
        </div>

    </div>
</div>
</body>
</html>
