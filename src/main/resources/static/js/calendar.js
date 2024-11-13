var Cal = function(divId) {
    this.divId = divId;

    this.DaysOfWeek = [
        'Пн',
        'Вт',
        'Ср',
        'Чтв',
        'Птн',
        'Суб',
        'Вск'
    ];

    this.Months = ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'];

    var d = new Date();

    this.currMonth = d.getMonth();
    this.currYear = d.getFullYear();
    this.currDay = d.getDate();
};

Cal.prototype.nextMonth = function() {
    if (this.currMonth === 11) {
        this.currMonth = 0;
        this.currYear += 1;
    } else {
        this.currMonth += 1;
    }
    this.showcurr();
};

Cal.prototype.previousMonth = function() {
    if (this.currMonth === 0) {
        this.currMonth = 11;
        this.currYear -= 1;
    } else {
        this.currMonth -= 1;
    }
    this.showcurr();
};

Cal.prototype.showcurr = function() {
    this.showMonth(this.currYear, this.currMonth);
};

Cal.prototype.showMonth = function(y, m) {
    var d = new Date(),
        firstDayOfMonth = new Date(y, m, 1).getDay() - 1,
        lastDateOfMonth = new Date(y, m + 1, 0).getDate(),
        lastDayOfLastMonth = m === 0 ? new Date(y - 1, 11, 0).getDate() : new Date(y, m, 0).getDate();

    if (firstDayOfMonth < 0) firstDayOfMonth = 6;

    var html = '<table>';

    html += '<thead><tr>';

    html += '<td><button id="btnPrev"></button></td>';
    html += '<td colspan="5">' + this.Months[m] + ' ' + y + '</td>';
    html += '<td><button id="btnNext"></button></td>';

    html += '</tr></thead>';

    html += '<tr class="days">';
    for (var i = 0; i < this.DaysOfWeek.length; i++) {
        html += '<td>' + this.DaysOfWeek[i] + '</td>';
    }
    html += '</tr>';

    var i = 1;
    do {
        var dow = new Date(y, m, i).getDay() - 1;
        if (dow < 0) dow = 6;

        if (dow === 0) {
            html += '<tr>';
        }

        if (i === 1 && dow !== 0) {
            var k = lastDayOfLastMonth - firstDayOfMonth + 1;
            for (var j = 0; j < firstDayOfMonth; j++) {
                html += '<td class="not-current">' + k + '</td>';
                k++;
            }
        }

        var chk = new Date();
        var chkY = chk.getFullYear();
        var chkM = chk.getMonth();
        if (chkY === this.currYear && chkM === this.currMonth && i === this.currDay) {
            html += '<td class="today">' + i + '</td>';
        } else {
            html += '<td class="normal">' + i + '</td>';
        }

        if (dow === 6) {
            html += '</tr>';
        }

        else if (i === lastDateOfMonth) {
            var k = 1;
            for (dow; dow < 6; dow++) {
                html += '<td class="not-current">' + k + '</td>';
                k++;
            }
        }

        i++;
    } while (i <= lastDateOfMonth);

    html += '</table>';

    document.getElementById(this.divId).innerHTML = html;

    var self = this;
    document.getElementById('btnNext').onclick = function() {
        self.nextMonth();
    };

    document.getElementById('btnPrev').onclick = function() {
        self.previousMonth();
    };
};

window.onload = function() {
    var c = new Cal("divCal");
    c.showcurr();
}

function getId(id) {
    return document.getElementById(id);
}
