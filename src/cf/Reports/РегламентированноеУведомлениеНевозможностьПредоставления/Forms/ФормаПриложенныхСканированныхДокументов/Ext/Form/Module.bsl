﻿#Область ОбработчикиСобытийФормы
&НаКлиенте
Процедура Ок(Команда)
	Закрыть();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Подсистема работы с файлами недоступна, обратитесь к администратору'"));
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Уведомление", Уведомление);
	Параметры.Свойство("РедактируемыйУИД", РедактируемыйУИД);
	
	Для Каждого Стр1 Из Параметры.ПриложенныеФайлы.ПолучитьЭлементы() Цикл 
		НовСтр = ПриложенныеФайлы.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, Стр1);
		Для Каждого Стр2 Из Стр1.ПолучитьЭлементы() Цикл 
			НовСтр2 = НовСтр.ПолучитьЭлементы().Добавить();
			ЗаполнитьЗначенияСвойств(НовСтр2, Стр2);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПриложенныеФайлыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	Если Строка = Неопределено
		Или ПриложенныеФайлы.НайтиПоИдентификатору(Строка).ПолучитьРодителя() <> Неопределено Тогда 
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	СтрокаВДереве = ПриложенныеФайлы.НайтиПоИдентификатору(Строка);
	Для Каждого Элт Из ПараметрыПеретаскивания.Значение Цикл
		СтрКопирования = ПриложенныеФайлы.НайтиПоИдентификатору(Элт);
		ЗаполнитьЗначенияСвойств(СтрокаВДереве.ПолучитьЭлементы().Добавить(), СтрКопирования);
		СтрКопирования.ПолучитьРодителя().ПолучитьЭлементы().Удалить(СтрКопирования);
	КонецЦикла;
	
	Элементы.ПриложенныеФайлы.Развернуть(Строка, Истина);
	ВладелецФормы.СинхронизацияДереваПриложенныхФайлов(ПриложенныеФайлы);
КонецПроцедуры

&НаКлиенте
Процедура ПриложенныеФайлыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	Для Каждого Элт Из ПараметрыПеретаскивания.Значение Цикл 
		Если ПриложенныеФайлы.НайтиПоИдентификатору(Элт).ПолучитьРодителя() = Неопределено Тогда 
			Выполнение = Ложь;
			Возврат;
		КонецЕсли;
	КонецЦикла;
	ПараметрыПеретаскивания.ДопустимыеДействия = ДопустимыеДействияПеретаскивания.Перемещение;
КонецПроцедуры

#КонецОбласти

#Область КомандыСписка
&НаКлиенте
Процедура ДобавитьДокумент(Команда)
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьДокументЗавершение", ЭтотОбъект);
	ПоказатьВводЗначения(ОписаниеОповещения, "", "Введите наименование, реквизиты и прочие признаки документа");
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьДокументЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(РезультатВопроса) = Тип("Строка") 
		И ЗначениеЗаполнено(РезультатВопроса) Тогда 
		
		НовДок = ПриложенныеФайлы.ПолучитьЭлементы().Добавить();
		НовДок.Документ = РезультатВопроса;
		НовДок.УИДДокумент = Новый УникальныйИдентификатор;
		ВладелецФормы.Модифицированность = Истина;
		Элементы.ПриложенныеФайлыДобавитьФайл.Доступность = Истина;
		
		ВладелецФормы.СинхронизацияДереваПриложенныхФайлов(ПриложенныеФайлы);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайл(Команда)
	ТекущиеДанные = Элементы.ПриложенныеФайлы.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		ПоказатьПредупреждение(, "Необходимо выбрать документ для добавления файла");
		Возврат;
	КонецЕсли;
	
	Если ВладелецФормы.Модифицированность Или Не ЗначениеЗаполнено(ВладелецФормы.Объект.Ссылка) Тогда 
		ТекстВопроса = "Для добавления файла необходимо сохранить уведомление. Сохранить?";
		ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьФайлПослеСохранения", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 0);
		Возврат;
	КонецЕсли;
	
	АдресФайла  = "";
	ВыбИмяФайла = "";
	
	Оп = Новый ОписаниеОповещения("ДобавитьФайлЗавершение", ЭтотОбъект);
	
	Попытка
		НачатьПомещениеФайла(Оп, АдресФайла, ВыбИмяФайла, Истина, УникальныйИдентификатор);
	Исключение
		ШаблонСообщения = НСтр("ru = 'При загрузке файла возникла ошибка.
									 |%1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонСообщения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ПоказатьПредупреждение(, ТекстСообщения, , НСтр("ru = 'Ошибка'"));
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайлПослеСохранения(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ВладелецФормы.СохранитьДанные();
		Уведомление = ВладелецФормы.Объект.Ссылка;
		АдресФайла  = "";
		ВыбИмяФайла = "";
		
		Оп = Новый ОписаниеОповещения("ДобавитьФайлЗавершение", ЭтотОбъект);
		
		Попытка
			НачатьПомещениеФайла(Оп, АдресФайла, ВыбИмяФайла, Истина, УникальныйИдентификатор);
		Исключение
			ШаблонСообщения = НСтр("ru = 'При загрузке файла возникла ошибка.
										 |%1'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонСообщения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ПоказатьПредупреждение(, ТекстСообщения, , НСтр("ru = 'Ошибка'"));
		КонецПопытки;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайлЗавершение(Результат, АдресФайла, ВыбИмяФайла, Парам) Экспорт
	Если НЕ Результат Тогда
		Возврат;
	КонецЕсли;
	
	ТекстПредупреждения = "";
	
	Если НЕ (ВРег(Прав(ВыбИмяФайла, 4)) = ".TIF"
		ИЛИ ВРег(Прав(ВыбИмяФайла, 5)) = ".TIFF"
		ИЛИ ВРег(Прав(ВыбИмяФайла, 5)) = ".JPEG"
		ИЛИ ВРег(Прав(ВыбИмяФайла, 4)) = ".PDF"
		ИЛИ ВРег(Прав(ВыбИмяФайла, 4)) = ".PNG"
		ИЛИ ВРег(Прав(ВыбИмяФайла, 4)) = ".JPG") Тогда
		
		ТекстПредупреждения = НСтр(
			"ru='Файл приложения должен иметь одно из допустимых расширений: JPEG, PDF, TIF, PNG!'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	Каталог = "";
	СтрокаПоиска = ВыбИмяФайла;
	
	РазделительПути = ПолучитьРазделительПути();
	Пока СтрДлина(СтрокаПоиска) > 0 Цикл
		Если Прав(СтрокаПоиска, 1) = РазделительПути Тогда
			Каталог = Лев(СтрокаПоиска, СтрДлина(СтрокаПоиска));
			Прервать;
		Иначе
			СтрокаПоиска = Лев(СтрокаПоиска, СтрДлина(СтрокаПоиска) - 1);
		КонецЕсли;
	КонецЦикла;
	
	Элт = Элементы.ПриложенныеФайлы.ТекущиеДанные.ПолучитьРодителя();
	Если Элт = Неопределено Тогда 
		Элт = Элементы.ПриложенныеФайлы.ТекущиеДанные;
	КонецЕсли;
	ПодчЭлт = Элт.ПолучитьЭлементы().Добавить();
	
	Попытка
		ЗаполнитьСтруктуруДанныхФайла(АдресФайла, ВыбИмяФайла, Каталог, ПодчЭлт.ПолучитьИдентификатор());
		ВладелецФормы.ОбработкаПослеДобавленияПрисоединенногоФайла(ПодчЭлт.ПолучитьРодителя().Документ, ПодчЭлт.ПолучитьРодителя().УИДДокумент, ПодчЭлт.УИДФайл, ПодчЭлт.ПрисоединенныйФайл, ПодчЭлт.Документ);
	Исключение
		ШаблонСообщения = НСтр("ru = 'При загрузке файла возникла ошибка.
									 |%1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонСообщения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ПоказатьПредупреждение(, ТекстСообщения, , НСтр("ru = 'Ошибка'"));
		Возврат;
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруДанныхФайла(АдресФайла, ПолноеИмяФайла, Каталог, ИДВДереве) Экспорт 
	МодульРаботаСФайлами = ОбщегоНазначения.ОбщийМодуль("РаботаСФайлами");
	ИмяФайла = СтрЗаменить(ПолноеИмяФайла, Каталог, "");
	ИмяБезРасширения = Лев(ИмяФайла, СтрНайти(ИмяФайла, ".", НаправлениеПоиска.СКонца) - 1);
	ПараметрыФайла = Новый Структура;
	ПараметрыФайла.Вставить("ВладелецФайлов", Уведомление);
	ПараметрыФайла.Вставить("Автор", Неопределено);
	ПараметрыФайла.Вставить("ИмяБезРасширения", СтрЗаменить(Строка(Новый УникальныйИдентификатор), "-", ""));
	ПараметрыФайла.Вставить("РасширениеБезТочки", Неопределено);
	ПараметрыФайла.Вставить("ВремяИзменения", Неопределено);
	ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", Неопределено);
	ПараметрыФайла.Вставить("Служебный", Истина);
	НоваяСсылкаНаФайл = МодульРаботаСФайлами.ДобавитьФайл(ПараметрыФайла, АдресФайла, , "Файл создан автоматически из формы уведомления, редактирование запрещено.");
	Файл = ПриложенныеФайлы.НайтиПоИдентификатору(ИДВДереве);
	Файл.ПрисоединенныйФайл = НоваяСсылкаНаФайл;
	Файл.Документ = ИмяФайла;
	Файл.УИДФайл = Новый УникальныйИдентификатор;
	Файл.УИДДокумент = Файл.ПолучитьРодителя().УИДДокумент;
	Файл.ИндексКартинки = 2;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьФайл(Команда)
	ТекущиеДанные = Элементы.ПриложенныеФайлы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.УИДФайл) Тогда 
		УИДФайл = ТекущиеДанные.УИДФайл;
		УИДДокумент = ТекущиеДанные.ПолучитьРодителя().УИДДокумент;
		ПрисоединенныйФайл = ТекущиеДанные.ПрисоединенныйФайл;
		ТекущиеДанные.ПолучитьРодителя().ПолучитьЭлементы().Удалить(ТекущиеДанные);
		УдалитьФайлНаСервере(ПрисоединенныйФайл);
		ВладелецФормы.ОбработкаПослеУдаленияПрисоединенногоФайла(УИДДокумент, УИДФайл);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УдалитьФайлНаСервере(ПрисоединенныйФайл)
	Попытка
		ПрисоединенныйФайлОбъект = ПрисоединенныйФайл.ПолучитьОбъект();
		Если ПравоДоступа("Удаление", Метаданные.Справочники.РегламентированныйОтчетПрисоединенныеФайлы) Тогда 
			ПрисоединенныйФайлОбъект.Удалить();
		Иначе
			ПрисоединенныйФайлОбъект.ПометкаУдаления = Истина;
			ПрисоединенныйФайлОбъект.Записать();
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю("При установке пометки удаления присоединенного файла произошли ошибки");
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ПриложенныеФайлыПриАктивизацииСтроки(Элемент)
	ТекущиеДанные = Элементы.ПриложенныеФайлы.ТекущиеДанные;
	Элементы.ПриложенныеФайлыДобавитьФайл.Доступность = (ТекущиеДанные <> Неопределено);
	Элементы.ПриложенныеФайлыУдалитьДокумент.Доступность = ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.УИДДокумент);
	Элементы.ПриложенныеФайлыУдалитьФайл.Доступность = ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.УИДФайл);
КонецПроцедуры

&НаКлиенте
Процедура УдалитьДокумент(Команда)
	ТекущиеДанные = Элементы.ПриложенныеФайлы.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено И (Не ЗначениеЗаполнено(ТекущиеДанные.УИДФайл) И ЗначениеЗаполнено(ТекущиеДанные.УИДДокумент)) Тогда 
		МассивПрисоединенныхФайлов = Новый Массив;
		Для Каждого Стр Из ТекущиеДанные.ПолучитьЭлементы() Цикл
			МассивПрисоединенныхФайлов.Добавить(Стр.ПрисоединенныйФайл);
		КонецЦикла;
		УИДДокумент = ТекущиеДанные.УИДДокумент;
		
		ПриложенныеФайлы.ПолучитьЭлементы().Удалить(ТекущиеДанные);
		УдалитьДокументНаСервере(УИДДокумент, МассивПрисоединенныхФайлов);
		ВладелецФормы.ОбработкаПослеУдаленияДокумента(УИДДокумент);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УдалитьДокументНаСервере(УИДДокумент, МассивПрисоединенныхФайлов)
	ЕстьИсключение = Ложь;
	ПравоДоступаУдаление = ПравоДоступа("Удаление", Метаданные.Справочники.РегламентированныйОтчетПрисоединенныеФайлы);
	Для Каждого Элт Из МассивПрисоединенныхФайлов Цикл
		Попытка
			ПрисоединенныйФайлОбъект = Элт.ПолучитьОбъект();
			Если ПравоДоступаУдаление Тогда 
				ПрисоединенныйФайлОбъект.Удалить();
			Иначе
				ПрисоединенныйФайлОбъект.ПометкаУдаления = Истина;
				ПрисоединенныйФайлОбъект.Записать();
			КонецЕсли;
		Исключение
			ЕстьИсключение = Истина;
		КонецПопытки;
	КонецЦикла;
	
	Если ЕстьИсключение Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю("При установке пометки удаления присоединенного файла произошли ошибки");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриложенныеФайлыПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПриложенныеФайлыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаСервере
Функция ДанныеФайла(ПрисоединенныйФайл)
	Возврат РаботаСФайлами.ДвоичныеДанныеФайла(ПрисоединенныйФайл);
КонецФункции

&НаКлиенте
Процедура ПриложенныеФайлыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекущиеДанные = ПриложенныеФайлы.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если ЗначениеЗаполнено(ТекущиеДанные.ПрисоединенныйФайл) Тогда
#Если Не ВебКлиент Тогда
		ИмяПромежуточногоФайла = ПолучитьИмяВременногоФайла(Сред(ТекущиеДанные.Документ, СтрНайти(ТекущиеДанные.Документ, ".", НаправлениеПоиска.СКонца) + 1));
#Иначе
		ИмяПромежуточногоФайла = "";
		СтандартнаяОбработка = Ложь;
		Возврат;
#КонецЕсли
		Если ЗначениеЗаполнено(ИмяПромежуточногоФайла) Тогда 
			ДанныеФайла(ТекущиеДанные.ПрисоединенныйФайл).Записать(ИмяПромежуточногоФайла);
			ЗапуститьПриложение(ИмяПромежуточногоФайла);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
