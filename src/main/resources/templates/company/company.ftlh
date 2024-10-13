<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Companies</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            background-color: #f8f9fa;
        }
        .card {
            margin: 20px auto;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        .card-title {
            font-size: 1.5rem;
        }
        .card-body p {
            font-size: 1rem;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row">
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h2 class="card-title">${company.name!}</h2>
                    <p><strong>ИНН:</strong> ${company.inn!}</p>
                    <p><strong>ИНН директора:</strong> ${company.directorInn!}</p>
                    <p><strong>Логин:</strong> ${company.login!}</p>
                    <p><strong>Пароль:</strong> ${company.password!}</p>
                    <p><strong>ЭЦП:</strong> ${company.ecp!}</p>
                    <p><strong>Кабинет налоговиков:</strong> ${company.kabinetSalyk!}</p>
                    <p><strong>Пароль кабинета налоговиков:</strong> ${company.kabinetSalykPassword!}</p>
                    <p><strong>Налоговый режим:</strong> ${company.taxMode!}</p>
                    <p><strong>Организационно-правовая форма:</strong> ${company.opf!}</p>
                    <p><strong>Район ГНС:</strong> ${company.districtGns!}</p>
                    <p><strong>Номер социального фонда:</strong> ${company.socfundNumber!}</p>
                    <p><strong>Регистрационный номер МЖ:</strong> ${company.registrationNumberMj!}</p>
                    <p><strong>ОКПО:</strong> ${company.okpo!}</p>
                    <p><strong>Директор:</strong> ${company.director!}</p>
                    <p><strong>КЭД:</strong> ${company.ked!}</p>
                    <p><strong>Email:</strong> ${company.email!}</p>
                    <p><strong>Пароль Email:</strong> ${company.emailPassword!}</p>
                    <p><strong>Телефон:</strong> ${company.phone!}</p>
                    <p><strong>ЭСФ:</strong> ${company.esf!}</p>
                    <p><strong>Пароль ЭСФ:</strong> ${company.esfPassword!}</p>
                    <p><strong>ККМ:</strong> ${company.kkm!}</p>
                    <p><strong>Пароль ККМ:</strong> ${company.kkmPassword!}</p>
                    <p><strong>Свежая 1С:</strong> ${company.fresh1c!}</p>
                    <p><strong>Пароль свежей 1С:</strong> ${company.fresh1cPassword!}</p>
                    <p><strong>ЭТТН:</strong> ${company.ettn!}</p>
                    <p><strong>Пароль ЭТТН:</strong> ${company.ettnPassword!}</p>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
