﻿//@strict-types

#Область СлужебныйПрограммныйИнтерфейс

// Инициализирует ключ настроек отправки.
// 
// Возвращаемое значение:
// 	Структура:
// * Отправитель - ОпределяемыйТип.Организация
// * Получатель - ОпределяемыйТип.УчастникЭДО
// * Договор - ОпределяемыйТип.ДоговорСКонтрагентомЭДО
// * ВидДокумента - СправочникСсылка.ВидыДокументовЭДО
Функция НовыйКлючНастроекОтправки() Экспорт
	
	КлючНастроек = Новый Структура;
	КлючНастроек.Вставить("Отправитель");
	КлючНастроек.Вставить("Получатель");
	КлючНастроек.Вставить("Договор");
	КлючНастроек.Вставить("ВидДокумента", ПредопределенноеЗначение("Справочник.ВидыДокументовЭДО.ПустаяСсылка"));
	
	Возврат КлючНастроек;
	
КонецФункции

// Возвращает настройку отправки.
// 
// Возвращаемое значение:
// 	Структура:
// * Отправитель - ОпределяемыйТип.Организация
// * Получатель - ОпределяемыйТип.УчастникЭДО
// * Договор - ОпределяемыйТип.ДоговорСКонтрагентомЭДО
// * ВидДокумента - СправочникСсылка.ВидыДокументовЭДО
// * Формат - Строка
// * ИдентификаторОтправителя - Строка
// * ИдентификаторПолучателя - Строка
// * МаршрутПодписания - СправочникСсылка.МаршрутыПодписания
// * ТребуетсяОтветнаяПодпись - Булево
// * ТребуетсяИзвещениеОПолучении - Булево
// * ВыгружатьДополнительныеСведения - Булево
// * ВерсияФорматаУстановленаВручную - Булево
// * Формировать - Булево
// * СпособОбмена - ПеречислениеСсылка.СпособыОбменаЭД
// * ЗаполнениеКодаТовара - Строка
// * ОбменБезПодписи - Булево
// * ГотовностьКОбмену - Булево
Функция НоваяНастройкаОтправки() Экспорт
	
	Настройка = Новый Структура;
	Настройка.Вставить("Отправитель");
	Настройка.Вставить("Получатель");
	Настройка.Вставить("Договор");
	Настройка.Вставить("ВидДокумента", ПредопределенноеЗначение("Справочник.ВидыДокументовЭДО.ПустаяСсылка"));
	Настройка.Вставить("Формат", "");
	Настройка.Вставить("ИдентификаторОтправителя", "");
	Настройка.Вставить("ИдентификаторПолучателя", "");
	Настройка.Вставить("МаршрутПодписания", ПредопределенноеЗначение("Справочник.МаршрутыПодписания.ПустаяСсылка"));
	Настройка.Вставить("ТребуетсяОтветнаяПодпись", Ложь);
	Настройка.Вставить("ТребуетсяИзвещениеОПолучении", Ложь);
	Настройка.Вставить("ВыгружатьДополнительныеСведения", Ложь);
	Настройка.Вставить("ВерсияФорматаУстановленаВручную", Ложь);
	Настройка.Вставить("Формировать", Ложь);
	Настройка.Вставить("СпособОбмена", ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ПустаяСсылка"));
	Настройка.Вставить("ЗаполнениеКодаТовара", "");
	Настройка.Вставить("ОбменБезПодписи", Ложь);
	Настройка.Вставить("ГотовностьКОбмену", Ложь);
	Настройка.Вставить("ЭтоНастройкаОтправки", Истина);
	
	Возврат Настройка;
	
КонецФункции

// Возвращает ключ настроек отражения в учете.
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * Отправитель - ОпределяемыйТип.КонтрагентБЭД
// * Получатель - ОпределяемыйТип.Организация
// * ИдентификаторОтправителя - Строка -
// * ИдентификаторПолучателя - Строка
// * ВидДокумента - СправочникСсылка.ВидыДокументовЭДО
Функция НовыйКлючНастроекОтраженияВУчете() Экспорт
	
	КлючНастроек = Новый Структура;
	
	КлючНастроек.Вставить("ВидДокумента", "");
	КлючНастроек.Вставить("Отправитель", "");
	КлючНастроек.Вставить("Получатель", "");
	КлючНастроек.Вставить("ИдентификаторОтправителя", "");
	КлючНастроек.Вставить("ИдентификаторПолучателя", "");

	Возврат КлючНастроек;
	
КонецФункции

// См. НастройкиВнутреннегоЭДОКлиентСервер.НовоеОписаниеПолейКлючаНастройкиВнутреннегоЭДО
Функция НовоеОписаниеПолейКлючаНастройкиВнутреннегоЭДО() Экспорт
	
	Возврат НастройкиВнутреннегоЭДОКлиентСервер.НовоеОписаниеПолейКлючаНастройкиВнутреннегоЭДО();
	
КонецФункции

// Возвращает текущую версию настроек дополнительных полей по формуле.
// 
// Возвращаемое значение:
//  Строка - версия настроек дополнительных полей по формуле.
//
Функция ВерсияНастроекДополнительныхПолейПоФормуле() Экспорт
	Возврат "2.0";
КонецФункции

#Область ОбработкаНеисправностей

// Возвращает вид ошибки, описывающий ситуацию, когда отключена настройка использования обмена электронными документами.
// 
// Возвращаемое значение:
// 	См. ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки
Функция ВидОшибкиНеВключеноИспользованиеОбменаЭД() Экспорт
	
	ВидОшибки = ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки();
	ВидОшибки.Идентификатор = "НеВключеноИспользованиеОбменаЭД";
	ВидОшибки.ЗаголовокПроблемы = НСтр("ru = 'Не удалось выполнить операцию'");
	ВидОшибки.ОписаниеПроблемы = НСтр("ru = 'Использование обмена электронными документами выключено'");
	ВидОшибки.ОписаниеРешения = НСтр("ru = 'Для работы с электронными документами необходимо
			|в настройках системы <a href = ""включить"">включить</a> использование обмена электронными документами.'");
	ВидОшибки.ОбработчикиНажатия.Вставить("включить", "НастройкиЭДОКлиент.ВключитьИспользованиеОбменаЭД");
	
	Возврат ВидОшибки;
	
КонецФункции

#КонецОбласти

#КонецОбласти