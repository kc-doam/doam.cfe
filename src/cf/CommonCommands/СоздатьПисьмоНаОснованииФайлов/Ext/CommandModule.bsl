﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ИспользованиеЛегкойПочты = ПолучитьФункциональнуюОпциюИнтерфейса("ИспользованиеЛегкойПочты");
	ИспользованиеВстроеннойПочты = ПолучитьФункциональнуюОпциюИнтерфейса("ИспользованиеВстроеннойПочты");
	
	Если Не ИспользованиеЛегкойПочты И Не ИспользованиеВстроеннойПочты Тогда
		ТекстСообщения = НСтр("ru = 'Для отправки письма требуется включить использование встроенной или легкой почты.'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если ИспользованиеВстроеннойПочты Тогда	
		
		ВстроеннаяПочтаКлиент.СоздатьПисьмоНаОснованииФайлов(ПараметрКоманды);
		
	ИначеЕсли ИспользованиеЛегкойПочты Тогда
		
		ПараметрОбъекты = Новый Массив;
		Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
			ПараметрОбъекты = ПараметрКоманды;
		Иначе
			ПараметрОбъекты.Добавить(ПараметрКоманды);
		КонецЕсли;	

		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("Объекты", ПараметрОбъекты);
		
		ОткрытьФорму(
			"Обработка.ПочтовоеСообщение.Форма.Форма",
			ПараметрыОткрытия,,
			Новый УникальныйИдентификатор);
	КонецЕсли;	
	
КонецПроцедуры
