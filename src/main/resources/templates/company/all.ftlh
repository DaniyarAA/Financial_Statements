<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Список Компаний</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/static/js/edit.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css">
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
                <#if _csrf??>
                    <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                           value="${(_csrf.token)!'csrf-token'}"/>
                </#if>
                <h2 class="mt-3 mb-3 text-center">Наименование компании: ${company.name!}</h2>
                <div class="row">
                    <div class="col-md-6">
                        <ul class="list-group">
                            <li class="list-group-item">
                                <strong>ИНН:</strong> <span id="companyInn">${company.inn!}</span>
                                <button onclick="copyText('companyInn')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('companyInn', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>ИНН руководителя:</strong> <span id="directorInn">${company.directorInn!}</span>
                                <button onclick="copyText('directorInn')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('directorInn', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>Логин:</strong> <span id="login">${company.login!}</span>
                                <button onclick="copyText('login')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('login', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>Пароль:</strong> <span id="password" data-password="${company.password!}">••••••</span>
                                <button onclick="copyText('password')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('password', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                                <button onclick="togglePasswordVisibility('password')" title="Увидеть" class="btn btn-link p-0">
                                    <i class="bi bi-eye" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>ЭЦП:</strong> <span id="ecp">${company.ecp!}</span>
                                <button onclick="copyText('ecp')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('ecp', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>Salyk.kg логин:</strong> <span id="kabinetSalyk">${company.kabinetSalyk!}</span>
                                <button onclick="copyText('kabinetSalyk')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('kabinetSalyk', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>Salyk.kg пароль:</strong> <span id="kabinetSalykPassword" data-password="${company.kabinetSalykPassword!}">••••••</span>
                                <button onclick="copyText('kabinetSalykPassword')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('kabinetSalykPassword', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                                <button onclick="togglePasswordVisibility('kabinetSalykPassword')" title="Увидеть" class="btn btn-link p-0">
                                    <i class="bi bi-eye" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>Режим налогообложения:</strong> <span id="taxMode">${company.taxMode!}</span>
                                <button onclick="copyText('taxMode')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('taxMode', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>ОПФ:</strong> <span id="opf">${company.opf!}</span>
                                <button onclick="copyText('opf')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('opf', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>Район ГНС:</strong> <span id="districtGns">${company.districtGns!}</span>
                                <button onclick="copyText('districtGns')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('districtGns', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>Номер социального фонда:</strong> <span id="socfundNumber">${company.socfundNumber!}</span>
                                <button onclick="copyText('socfundNumber')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('socfundNumber', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>Регистрационный номер МЮ:</strong> <span id="registrationNumberMj">${company.registrationNumberMj!}</span>
                                <button onclick="copyText('registrationNumberMj')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('registrationNumberMj', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>ОКПО:</strong> <span id="okpo">${company.okpo!}</span>
                                <button onclick="copyText('okpo')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('okpo', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>ФИО руководителя:</strong> <span id="director">${company.director!}</span>
                                <button onclick="copyText('director')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('director', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>КЭД:</strong> <span id="ked">${company.ked!}</span>
                                <button onclick="copyText('ked')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('ked', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                        </ul>
                    </div>
                    <div class="col-md-6">
                        <ul class="list-group">
                            <li class="list-group-item">
                                <strong>Почта:</strong> <span id="email">${company.email!}</span>
                                <button onclick="copyText('email')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('email', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>Пароль от почты:</strong> <span id="emailPassword" data-password="${company.emailPassword!}">••••••</span>
                                <button onclick="copyText('emailPassword')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('emailPassword', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                                <button onclick="togglePasswordVisibility('emailPassword')" title="Увидеть" class="btn btn-link p-0">
                                    <i class="bi bi-eye" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>Телефон:</strong> <span id="phone">${company.phone!}</span>
                                <button onclick="copyText('phone')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('phone', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>ЭСФ логин:</strong> <span id="esf">${company.esf!}</span>
                                <button onclick="copyText('esf')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('esf', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>ЭСФ пароль:</strong> <span id="esfPassword" data-password="${company.esfPassword!}">••••••</span>
                                <button onclick="copyText('esfPassword')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('esfPassword', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                                <button onclick="togglePasswordVisibility('esfPassword')" title="Увидеть" class="btn btn-link p-0">
                                    <i class="bi bi-eye" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>ККМ логин:</strong> <span id="kkm">${company.kkm!}</span>
                                <button onclick="copyText('kkm')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('kkm', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>ККМ пароль:</strong> <span id="kkmPassword" data-password="${company.kkmPassword!}">••••••</span>
                                <button onclick="copyText('kkmPassword')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('kkmPassword', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                                <button onclick="togglePasswordVisibility('kkmPassword')" title="Увидеть" class="btn btn-link p-0">
                                    <i class="bi bi-eye" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>1С Фреш логин:</strong> <span id="fresh1c">${company.fresh1c!}</span>
                                <button onclick="copyText('fresh1c')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('fresh1c', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>1С Фреш пароль:</strong> <span id="fresh1cPassword" data-password="${company.fresh1cPassword!}">••••••</span>
                                <button onclick="copyText('fresh1cPassword')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('fresh1cPassword', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                                <button onclick="togglePasswordVisibility('fresh1cPassword')" title="Увидеть" class="btn btn-link p-0">
                                    <i class="bi bi-eye" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>ЭТТН логин:</strong> <span id="ettn">${company.ettn!}</span>
                                <button onclick="copyText('ettn')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('ettn', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>ЭТТН пароль:</strong> <span id="ettnPassword" data-password="${company.ettnPassword!}">••••••</span>
                                <button onclick="copyText('ettnPassword')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('ettnPassword', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                                <button onclick="togglePasswordVisibility('ettnPassword')" title="Увидеть" class="btn btn-link p-0">
                                    <i class="bi bi-eye" style="color: black;"></i>
                                </button>
                            </li>
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
