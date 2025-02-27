﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Обработчик события ПередЗаписью предотвращает изменение видов доступа,
// которые должны изменятся только в режиме конфигурирования.
//
Процедура ПередЗаписью(Отказ)
	
	Если Предопределенный И ОбменДанными.Загрузка Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "ТипЗначения, Наименование"));
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ВызватьИсключение(НСтр("ru = 'Изменение видов доступа
	                             |выполняется только через конфигуратор.
	                             |
	                             |Удаление допустимо.'"));
	
КонецПроцедуры

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли