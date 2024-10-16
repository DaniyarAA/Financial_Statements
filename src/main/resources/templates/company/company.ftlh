<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Компания</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@600&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Roboto', sans-serif;
        }
        .card {
            margin: 20px auto;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            background-color: #ffffff;
        }
        .card-title {
            font-size: 1.5rem;
            color: #007bff;
            font-family: 'Dancing Script', cursive;
        }
        .card-body p {
            font-size: 1rem;
            color: #495057;
            margin-bottom: 10px;
        }
        .card-body p strong {
            color: #343a40;
        }
        .main-title {
            text-align: center;
            color: #6c757d;
            font-family: 'Dancing Script', cursive;
            font-size: 3rem;
            margin-bottom: 30px;
        }
        .section-title {
            font-family: 'Dancing Script', cursive;
            font-size: 1.8rem;
            color: #6c757d;
            margin-top: 20px;
            margin-bottom: 10px;
        }
        .section-separator {
            border-top: 1px solid #dee2e6;
            margin: 20px 0;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card">
                <div class="card-body">
                    <h1 class="main-title">Полная информация о компании</h1>
                    <div class="section-separator"></div>
                    <h3 class="section-title">Обязательные данные</h3>
                    <p><strong>Наименование компании:</strong> ${company.name!}</p>
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
                    <div class="section-separator"></div>
                    <h3 class="section-title">Опциональные данные</h3>
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
    </div>
</div>
</body>
</html>
