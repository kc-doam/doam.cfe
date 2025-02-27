﻿//Получает реквизит данных файла
//
//Параметры:
//  Файл - ссылка на объект файл
//  НазваниеПоля - наименование реквизита, которое необходимо получить
//  ФактическийВладелецФайла - ссылка на владельца файла, на основании которого следует производить подстановку данных
//
//Возвращает:
//  Значение поля, если оно существует
//
Функция ПолучитьЗначениеРеквизитаДляАвтозаполнения(Файл, НазваниеПоля, ФактическийВладелецФайла) Экспорт
	
	Результат = "";
	НазваниеПоля = СтрЗаменить(НазваниеПоля, "Файл|", "");
	НазваниеПоля = СтрЗаменить(НазваниеПоля, "Файл.", "");	
	Попытка
		Если Найти(НазваниеПоля, "|") > 0 Тогда
			МассивСтрок = СтрРазделить(НазваниеПоля, "|");
			НазваниеПоля = СтрЗаменить(НазваниеПоля, "|", ".");
		Иначе
			МассивСтрок = СтрРазделить(НазваниеПоля, ".");
		КонецЕсли;
		
		Выражение = "Если НЕ Файл.Пустая()";
		ВыражениеРеквизита = "Файл";
		Счетчик = 0;
		Для Каждого Реквизит Из МассивСтрок Цикл
			Счетчик = Счетчик + 1;
			ВыражениеРеквизита = ВыражениеРеквизита + "." + Реквизит;
			Если Счетчик < МассивСтрок.Количество() Тогда
				Выражение = Выражение + Символы.ВК + "И НЕ " + ВыражениеРеквизита + " = Неопределено"
					+ " И НЕ " + ВыражениеРеквизита + ".Пустая()";
			КонецЕсли;
		КонецЦикла;
		Выражение = Выражение + Символы.ВК + "И ЗначениеЗаполнено(Файл." + НазваниеПоля + ")";
		Выражение = Выражение + " Тогда " + Символы.ВК + "Результат = Файл." + НазваниеПоля + ";" + Символы.ВК + "КонецЕсли;";
		Выражение = СтрЗаменить(Выражение, "Файл.ВладелецФайла", "ФактическийВладелецФайла");
		УстановитьПривилегированныйРежим(Истина);
		Выполнить(Выражение);
		УстановитьПривилегированныйРежим(Ложь);
	Исключение
		Инфо = ИнформацияОбОшибке();
		ВызватьИсключение("ОшибкаДоступаКРеквизиту");
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

//Получает значение доп. реквизита данных файла
//
//Параметры:
//  Файл - ссылка на объект файл
//  НазваниеПоля - наименование реквизита, которое необходимо получить
//  ФактическийВладелецФайла - ссылка на владельца файла, на основании которого следует производить подстановку данных
//
//Возвращает:
//  Значение поля, если оно существует
//
Функция ПолучитьЗначениеДопРеквизитаДляЗамены(Файл, НазваниеПоля, ФактическийВладелецФайла) Экспорт 
	
	Результат = "";
	
	Если Найти(НазваниеПоля, "|") > 0 Тогда
		МассивСтрок = СтрРазделить(НазваниеПоля, "|");
	Иначе
		МассивСтрок = СтрРазделить(НазваниеПоля, ".");
	КонецЕсли;
	Если МассивСтрок.Количество() = 1
		Или Не ЗначениеЗаполнено(ФактическийВладелецФайла) Тогда
		Возврат Результат;
	КонецЕсли;
	ИмяДопРеквизита = МассивСтрок[МассивСтрок.Количество() - 1];
	
	Счетчик = 0; РеквизитВладельца = Ложь;
	Пока Счетчик < 2 Цикл
		Счетчик = Счетчик + 1;
		Для Каждого Строка Из МассивСтрок Цикл
			Если Найти(Строка, "ВладелецФайла.ДопСвойства") > 0
				Или Найти(Строка, "ВладелецФайла.ДопРеквизиты") > 0 Тогда
				РеквизитВладельца = Истина;
			КонецЕсли;
			
			Если Найти(Строка, "ДопСвойства") > 0
				Или Найти(Строка, "ДопРеквизиты") > 0 Тогда
				МассивСтрок.Удалить(МассивСтрок.Найти(Строка));
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Выражение = "Если НЕ Файл.Пустая()";
	Если РеквизитВладельца Тогда 
		ВыражениеРеквизита = "Файл.ВладелецФайла";
	Иначе 
		ВыражениеРеквизита = "Файл";
	КонецЕсли;
	
	Счетчик = 0;
	Для Каждого Реквизит Из МассивСтрок Цикл
		Счетчик = Счетчик + 1;
		
		Если Найти(Реквизит, " ") > 0
			Или Реквизит = Строка(ФактическийВладелецФайла.ВидДокумента) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Счетчик < МассивСтрок.Количество() Тогда
			ВыражениеРеквизита = ВыражениеРеквизита + "." + Реквизит;
			Выражение = Выражение + Символы.ВК + "И НЕ " + ВыражениеРеквизита + " = Неопределено"
				+ " И НЕ " + ВыражениеРеквизита + ".Пустая()";
		КонецЕсли;
	КонецЦикла;	
	
	ВыражениеЦикла = 
		"Для Каждого ДопРеквизит Из " + ВыражениеРеквизита + ".ДополнительныеРеквизиты Цикл
			|Если (Строка(ДопРеквизит.Свойство) = ИмяДопРеквизита) 
			|	Или (ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДопРеквизит.Свойство, ""Заголовок"") = ИмяДопРеквизита) Тогда
			|	Результат = ДопРеквизит.Значение;
			|КонецЕсли;
		|КонецЦикла;";
	
	Выражение = Выражение + " Тогда " + ВыражениеЦикла + "КонецЕсли;";
	Выражение = СтрЗаменить(Выражение, "Файл.ВладелецФайла", "ФактическийВладелецФайла");
	УстановитьПривилегированныйРежим(Истина);
	Выполнить(Выражение);
	
	Если Результат = "" Тогда 
		МассивСвойств = УправлениеСвойствами.СвойстваОбъекта(ФактическийВладелецФайла);
		
		Для Каждого ДопСвойство Из МассивСвойств Цикл 
			Если ДопСвойство.Наименование = ИмяДопРеквизита 
				Или ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДопСвойство.Ссылка, "Заголовок") = ИмяДопРеквизита Тогда
				Если СокрЛП(ДопСвойство.ТипЗначения) = "Булево" Тогда 
					Результат = Ложь;
				КонецЕсли;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	// Возможно реквизит неограниченной длины, он хранится в рекизите "ТекстоваяСтрока"
	ИначеЕсли СтрДлина(Результат) = 1024 Тогда 
		МассивСвойств = УправлениеСвойствами.СвойстваОбъекта(ФактическийВладелецФайла);
		
		Для Каждого ДопСвойство Из МассивСвойств Цикл 
			Если ДопСвойство.Наименование = ИмяДопРеквизита Тогда 
				Если СокрЛП(ДопСвойство.ТипЗначения) = "Строка" 
					Или ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДопСвойство.Ссылка, "Заголовок") = ИмяДопРеквизита Тогда 
					СтрокаДопРеквизитов = ФактическийВладелецФайла.ДополнительныеРеквизиты.Найти(ДопСвойство,"Свойство");
					Если СтрокаДопРеквизитов <> Неопределено И ЗначениеЗаполнено(СтрокаДопРеквизитов.ТекстоваяСтрока) Тогда 
						Результат = СтрокаДопРеквизитов.ТекстоваяСтрока;
					КонецЕсли;
				КонецЕсли;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
		
	Возврат Результат;
	
КонецФункции

Функция ПолучитьЗначениеКонтактнойИнформацииДляЗамены(Файл, НазваниеПоля, ФактическийВладелецФайла) Экспорт
	
	Результат = "";
	Если Найти(НазваниеПоля, "|") > 0 Тогда
		МассивСтрок = СтрРазделить(НазваниеПоля, "|");
	Иначе
		МассивСтрок = СтрРазделить(НазваниеПоля, ".");
	КонецЕсли;
	
	Если МассивСтрок.Количество() = 1
		Или НЕ ЗначениеЗаполнено(ФактическийВладелецФайла) Тогда
		Возврат Результат;
	КонецЕсли;
	ИмяКонтИнформации = МассивСтрок[МассивСтрок.Количество() - 1];
	
	Счетчик = 0;
	Пока Счетчик < 2 Цикл
		Счетчик = Счетчик + 1;
		Для Каждого Строка Из МассивСтрок Цикл
			Если Найти(Строка, НСтр("ru = 'КонтактнаяИнформация'")) Тогда
				МассивСтрок.Удалить(МассивСтрок.Найти(Строка));
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Выражение = "Если НЕ Файл.Пустая()";
	ВыражениеРеквизита = "Файл";
	Счетчик = 0;
	Для Каждого Реквизит Из МассивСтрок Цикл
		Счетчик = Счетчик + 1;
		
		Если Найти(Реквизит, " ") > 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Если Счетчик < МассивСтрок.Количество() Тогда
			ВыражениеРеквизита = ВыражениеРеквизита + "." + Реквизит;
			Выражение = Выражение + Символы.ВК + "И НЕ " + ВыражениеРеквизита + " = Неопределено"
				+ " И НЕ " + ВыражениеРеквизита + ".Пустая()";
		КонецЕсли;
	КонецЦикла;	
	
	ВыражениеЦикла = 
		"Для Каждого КонтИнформация Из " + ВыражениеРеквизита + ".КонтактнаяИнформация Цикл
			|Если Строка(КонтИнформация.Вид.Наименование) = ИмяКонтИнформации Тогда
			|	Результат = КонтИнформация.Представление;
			|КонецЕсли;
		|КонецЦикла;";
	
	Выражение = Выражение + " Тогда " + ВыражениеЦикла + "КонецЕсли;";
	Выражение = СтрЗаменить(Выражение, "Файл.ВладелецФайла", "ФактическийВладелецФайла");
	УстановитьПривилегированныйРежим(Истина);
	Выполнить(Выражение);
	УстановитьПривилегированныйРежим(Ложь);
	Возврат Результат;
	
КонецФункции

//Получает реквизит данных файла
//
//Параметры:
//  Файл - ссылка на объект файл
//  НазваниеПоля - наименование реквизита, которое необходимо получить
//  ФактическийВладелецФайла - ссылка на владельца файла, на основании которого следует производить подстановку данных
//
//Возвращает:
//  Значение поля, если оно существует
//
Функция ПолучитьЗначениеРеквизитаТабличнойЧастиДляАвтозаполнения(Файл, НазваниеПоля, ФактическийВладелецФайла) Экспорт
	
	Результат = "";
	НазваниеПоля = СтрЗаменить(НазваниеПоля, "ВладелецФайла|", "");
	НазваниеПоля = СтрЗаменить(НазваниеПоля, "ВладелецФайла.", "");
	
	Если Найти(НазваниеПоля, "|") > 0 Тогда
		МассивСтрок = СтрРазделить(НазваниеПоля, "|");
	Иначе
		МассивСтрок = СтрРазделить(НазваниеПоля, ".");
	КонецЕсли;
	Если МассивСтрок.Количество() = 1
		Или Не ЗначениеЗаполнено(ФактическийВладелецФайла) Тогда
		Возврат Результат;
	КонецЕсли;
	ИмяРеквизита = МассивСтрок[МассивСтрок.Количество() - 1];
	
	Счетчик = 0; ЭтоДопРеквизиты = Ложь;
	Пока Счетчик < 2 Цикл
		Счетчик = Счетчик + 1;
		Для Каждого Строка Из МассивСтрок Цикл
			Если Найти(Строка, "ДопСвойства") > 0
				Или Найти(Строка, "ДопРеквизиты") > 0 Тогда
				ЭтоДопРеквизиты = Истина;
				МассивСтрок.Удалить(МассивСтрок.Найти(Строка));
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Счетчик = 0;ВыражениеРеквизита = "";
	Для Каждого Реквизит Из МассивСтрок Цикл
		Счетчик = Счетчик + 1;
		Если Реквизит = "ТабличнаяЧасть" Тогда 
			Продолжить;
		КонецЕсли;
		
		Если Найти(Реквизит, " ") > 0
			Или Реквизит = Строка(ФактическийВладелецФайла.ВидДокумента) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Счетчик < МассивСтрок.Количество() Тогда
			ВыражениеРеквизита = ВыражениеРеквизита + "." + Реквизит;
		КонецЕсли;
	КонецЦикла;
	
	Если Лев(ВыражениеРеквизита, 1) = "." Тогда 
		ВыражениеРеквизита = Прав(ВыражениеРеквизита, СтрДлина(ВыражениеРеквизита) - 1);
	КонецЕсли;
	
	Результат = "";
	Попытка
		УстановитьПривилегированныйРежим(Истина);
		
		МассивТоваров = Новый Массив;
		Если ФактическийВладелецФайла <> Неопределено Тогда 
			Для Каждого Стр Из ФактическийВладелецФайла.Товары Цикл 
				Структура = Новый Структура;
				Структура.Вставить("НомерСтроки", Стр.НомерСтроки);
				
				Если ЗначениеЗаполнено(ВыражениеРеквизита) Тогда 
					ЗначениеРеквизитаРодителя = Стр[ВыражениеРеквизита];
					Если ЗначениеЗаполнено(ЗначениеРеквизитаРодителя) Тогда 
						Если ЭтоДопРеквизиты Тогда 
							ЗначениеРеквизита = ПолучитьЗначениеДопРеквизитаТЧ(ЗначениеРеквизитаРодителя, ИмяРеквизита);
							Структура.Вставить("Значение", ЗначениеРеквизита);
						Иначе 
							ЗначениеРеквизита = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗначениеРеквизитаРодителя, ИмяРеквизита);
							Структура.Вставить("Значение", ЗначениеРеквизита);
						КонецЕсли;
					КонецЕсли;
				Иначе 
					Структура.Вставить("Значение", Стр[ИмяРеквизита]);
				КонецЕсли;
				
				МассивТоваров.Добавить(Структура);
			КонецЦикла;
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Ложь);
	Исключение
		Инфо = ИнформацияОбОшибке();
		ВызватьИсключение(Инфо.Описание);
	КонецПопытки;
	
	Возврат МассивТоваров;
	
КонецФункции

Функция ПолучитьЗначениеДопРеквизитаТЧ(ЗначениеРеквизита, ИмяДопРеквизита) 
	
	Результат = "";
	
	Выражение = "Если НЕ ЗначениеРеквизита.Пустая()";
	ВыражениеЦикла = 
		"Для Каждого ДопРеквизит Из ЗначениеРеквизита.ДополнительныеРеквизиты Цикл
			|Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДопРеквизит.Свойство, ""Заголовок"") = ИмяДопРеквизита Тогда
			|	Результат = ДопРеквизит.Значение;
			|КонецЕсли;
		|КонецЦикла;";
	
	Выражение = Выражение + " Тогда " + ВыражениеЦикла + "КонецЕсли;";
	УстановитьПривилегированныйРежим(Истина);
	Выполнить(Выражение);
	
	Если Результат = "" Тогда 
		МассивСвойств = УправлениеСвойствами.СвойстваОбъекта(ЗначениеРеквизита);
		
		Для Каждого ДопСвойство Из МассивСвойств Цикл 
			Если ДопСвойство.Заголовок = ИмяДопРеквизита Тогда  
				Если СокрЛП(ДопСвойство.ТипЗначения) = "Булево" Тогда 
					Результат = Ложь;
				КонецЕсли;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	// Возможно реквизит неограниченной длины, он хранится в рекизите "ТекстоваяСтрока"
	ИначеЕсли СтрДлина(Результат) = 1024 Тогда 
		МассивСвойств = УправлениеСвойствами.СвойстваОбъекта(ЗначениеРеквизита);
		
		Для Каждого ДопСвойство Из МассивСвойств Цикл 
			Если ДопСвойство.Наименование = ИмяДопРеквизита Тогда  
				Если СокрЛП(ДопСвойство.ТипЗначения) = "Строка" Тогда 
					СтрокаДопРеквизитов = ЗначениеРеквизита.ДополнительныеРеквизиты.Найти(ДопСвойство,"Свойство");
					Если СтрокаДопРеквизитов <> Неопределено И ЗначениеЗаполнено(СтрокаДопРеквизитов.ТекстоваяСтрока) Тогда 
						Результат = СтрокаДопРеквизитов.ТекстоваяСтрока;
					КонецЕсли;
				КонецЕсли;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
		
	Возврат Результат;
	
КонецФункции
