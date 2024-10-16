<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Список Компаний</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            background-color: #f8f9fa;
        }
        .card {
            margin: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        .card-title {
            font-size: 1.5rem;
        }
        .card-body p {
            font-size: 1rem;
        }
        .main-title{
            text-align: center;
        }
    </style>
</head>
<body>
<div class="container">
    <h1 class="main-title">Список Компании</h1>
    <div class="row">
        <#list list as company>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body">
                        <h2 class="card-title">Наименование компании: ${company.name!}</h2>
                        <p><strong>ИНН:</strong> ${company.inn!}</p>
                        <p><strong>ИНН руководителя:</strong> ${company.directorInn!}</p>
                        <p><strong>Логин:</strong> ${company.login!}</p>
                        <p><strong>Пароль:</strong> ${company.password!}</p>
                        <p><strong>ЭЦП:</strong> ${company.ecp!}</p>
                        <p><strong>Salyk.kg логин:</strong> ${company.kabinetSalyk!}</p>
                        <p><strong>Salyk.kg пароль:</strong> ${company.kabinetSalykPassword!}</p>
                        <p><strong>Режим налогооблажения:</strong> ${company.taxMode!}</p>
                        <p><strong>ОПФ:</strong> ${company.opf!}</p>
                        <p><strong>Район ГНС:</strong> ${company.districtGns!}</p>
                        <p><strong>Номер социального фонда:</strong> ${company.socfundNumber!}</p>
                        <p><strong>Регистрационный номер МЮ:</strong> ${company.registrationNumberMj!}</p>
                        <p><strong>ОКПО:</strong> ${company.okpo!}</p>
                        <p><strong>ФИО руководителя:</strong> ${company.director!}</p>
                        <p><strong>КЭД:</strong> ${company.ked!}</p>
                        <p><strong>Почта:</strong> ${company.email!}</p>
                        <p><strong>Пароль от почты:</strong> ${company.emailPassword!}</p>
                        <p><strong>Телефон:</strong> ${company.phone!}</p>
                        <p><strong>ЭСФ логин:</strong> ${company.esf!}</p>
                        <p><strong>ЭСФ пароль:</strong> ${company.esfPassword!}</p>
                        <p><strong>ККМ логин:</strong> ${company.kkm!}</p>
                        <p><strong>ККМ пароль:</strong> ${company.kkmPassword!}</p>
                        <p><strong>1С Фреш логин:</strong> ${company.fresh1c!}</p>
                        <p><strong>1С Фреш пароль:</strong> ${company.fresh1cPassword!}</p>
                        <p><strong>ЭТТН логин:</strong> ${company.ettn!}</p>
                        <p><strong>ЭТТН пароль:</strong> ${company.ettnPassword!}</p>
                    </div>
                </div>
            </div>
        </#list>
    </div>
</div>
</body>
</html>
