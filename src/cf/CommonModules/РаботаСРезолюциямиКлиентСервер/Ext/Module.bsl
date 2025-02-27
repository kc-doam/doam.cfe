﻿////////////////////////////////////////////////////////////////////////////////
// МОДУЛЬ ДЛЯ РАБОТЫ С РЕЗОЛЮЦИЯМИ (КЛИЕНТ-СЕРВЕР)
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Функция ПолучитьНаименованиеРезолюции(Документ) Экспорт
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Резолюция документа ""%1""'"), Строка(Документ));
	
КонецФункции

Функция СообщениеДоступНаУдалениеЗакрыт() Экспорт
	
	Возврат НСтр("ru = 'Удалить резолюцию может только автор либо внесший.'");
	
КонецФункции

Функция ПолучитьИнформациюОбЭПРезолюции(Резолюция) Экспорт
	
	Результат = "";
	
	Если Не Резолюция.Подписана Тогда
		Возврат НСтр("ru = 'Не подписана'");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Резолюция.ДатаПроверкиПодписи) Тогда
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1, подпись не проверена'"),
			Резолюция.ДатаПодписи);
	КонецЕсли;
	
	Если Не Резолюция.ПодписьВерна Тогда
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1, подпись неверна'"),
			Резолюция.ДатаПодписи);
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1, подпись верна'"),
		Резолюция.ДатаПодписи);
	
КонецФункции

#КонецОбласти
