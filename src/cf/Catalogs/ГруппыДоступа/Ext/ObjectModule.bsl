﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Обработчик события ПередЗаписью формирует временную таблицу старых пользователей
// для обработчика ПриЗаписи.
//
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Следующие проверки до "ОбменДанными.Загрузка" необходимы,
	// чтобы предотвратить возможность ответственному за группу доступа
	// повысить себя до администратора программным путем,
	// т.к. запись групп доступа разрешена ответственным пользователям.
	Если Ссылка = Справочники.ГруппыДоступа.Администраторы Тогда
		// Всегда предопределенный профиль Администратор
		Профиль = Справочники.ПрофилиГруппДоступа.Администратор;
		// Не может быть персональной группой доступа
		Пользователь = Неопределено;
		// Только обычные пользователи
		ТипПользователей = Справочники.Пользователи.ПустаяСсылка();
		// Изменение разрешено только полноправному пользователю
		Если НЕ ПривилегированныйРежим()
		   И НЕ ПользователиСерверПовтИсп.ЭтоПолноправныйПользовательИБ() Тогда
			
			ВызватьИсключение(НСтр("ru = 'Предопределенную группу доступа Администраторы
			                             |можно изменять, либо в привилегированном режиме,
			                             |либо при наличии роли ""Полные права"".'"));
		КонецЕсли;
		// Нельзя устанавливать предопределенный профиль Администратор произвольной группе доступа
	ИначеЕсли Профиль = Справочники.ПрофилиГруппДоступа.Администратор Тогда
		ВызватьИсключение(НСтр("ru = 'Предопределенный профиль Администратор может быть только
		                             |у предопределенной группы доступа Администраторы.'"));
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		
		Если НЕ ДополнительныеСвойства.Свойство("НеОбновлятьРолиПользователей") Тогда
			
			Если ЗначениеЗаполнено(Ссылка) Тогда
				СтараяТаблицаПользователи = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Пользователи");
				СтарыеУчастникиГруппыДоступа = СтараяТаблицаПользователи.Выгрузить().ВыгрузитьКолонку("Пользователь");
			Иначе
				СтарыеУчастникиГруппыДоступа = Новый Массив;
			КонецЕсли;
			
			ДополнительныеСвойства.Вставить("СтарыеУчастникиГруппыДоступа", СтарыеУчастникиГруппыДоступа);
		КонецЕсли;
		
		// Автоматическая установка реквизитов для персональной группы доступа
		Если ЗначениеЗаполнено(Пользователь) Тогда
			Родитель         = Справочники.ГруппыДоступа.РодительПерсональныхГруппДоступа();
			ТипПользователей = Неопределено;
		Иначе
			Пользователь = Неопределено;
			Если Родитель = Справочники.ГруппыДоступа.РодительПерсональныхГруппДоступа(Истина) Тогда
				Родитель = Неопределено;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события ПриЗаписи обновляет
// - роли добавленных, оставшихся и удаленных пользователей;
// - РегистрСведений.ПраваГруппДоступаНаТаблицы;
// - РегистрСведений.ЗначенияГруппДоступа.
//
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ДополнительныеСвойства.Свойство("НеОбновлятьРолиПользователей") Тогда
		
		ЕстьОшибки = Ложь;
		ОбновитьРолиПользователей(Ссылка, ДополнительныеСвойства.СтарыеУчастникиГруппыДоступа, ЕстьОшибки);
		Если ЕстьОшибки Тогда
			ДополнительныеСвойства.Вставить("ЕстьОшибки");
		КонецЕсли;
	КонецЕсли;
	
	// Обновление связанных регистров сведений
	//РегистрыСведений.ЗначенияГруппДоступа.ОбновитьДанныеРегистра(Ссылка);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

Процедура ОбновитьРолиПользователей(ГруппаДоступа, СтарыеУчастникиГруппыДоступа, ЕстьОшибки = Ложь)
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Обновление ролей для добавленных, оставшихся и удаленных пользователей.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ГруппаДоступа", ГруппаДоступа);
	Запрос.УстановитьПараметр("СтарыеУчастникиГруппыДоступа", СтарыеУчастникиГруппыДоступа);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СоставыГруппПользователей.Пользователь КАК Пользователь
	|ИЗ
	|	РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
	|ГДЕ
	|	СоставыГруппПользователей.ГруппаПользователей В(&СтарыеУчастникиГруппыДоступа)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	СоставыГруппПользователей.Пользователь
	|ИЗ
	|	Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
	|		ПО ГруппыДоступаПользователи.Пользователь = СоставыГруппПользователей.ГруппаПользователей
	|			И (ГруппыДоступаПользователи.Ссылка = &ГруппаДоступа)";
	СтарыеИНовыеПользователи = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Пользователь");
	
	Если ГруппаДоступа = Справочники.ГруппыДоступа.Администраторы Тогда
		// Добавление пользователей, связанных с пользователямиИБ, имеющих роль ПолныеПрава
		Для каждого ПользовательИБ Из ПользователиИнформационнойБазы.ПолучитьПользователей() Цикл
			Если ПользовательИБ.Роли.Содержит(Метаданные.Роли.ПолныеПрава) Тогда
				НайденныйПользователь = Справочники.Пользователи.НайтиПоРеквизиту("ИдентификаторПользователяИБ", ПользовательИБ.УникальныйИдентификатор);
				Если НЕ ЗначениеЗаполнено(НайденныйПользователь) Тогда
					НайденныйПользователь = Справочники.ВнешниеПользователи.НайтиПоРеквизиту("ИдентификаторПользователяИБ", ПользовательИБ.УникальныйИдентификатор);
				КонецЕсли;
				Если ЗначениеЗаполнено(НайденныйПользователь)
				   И СтарыеИНовыеПользователи.Найти(НайденныйПользователь) = Неопределено Тогда
					СтарыеИНовыеПользователи.Добавить(НайденныйПользователь);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	УправлениеДоступом.ОбновитьРолиПользователей(СтарыеИНовыеПользователи, ЕстьОшибки);
	
КонецПроцедуры

#КонецЕсли
