// Таблица для хранения списка всех добавленных реквизитов, 
// аналог Свойства_ОписаниеДополнительныхРеквизитов в стандартной форме
&НаСервере
Процедура РасшДОАМ_СоздатьТаблицуОписанияРасширенныхРеквизитов(Реквизиты)
	
	ИмяОписания = "ТаблицаОписанияРасширенныхРеквизитов";
	
	Реквизиты.Добавить(Новый РеквизитФормы(
		ИмяОписания, Новый ОписаниеТипов("ТаблицаЗначений")));

	Реквизиты.Добавить(Новый РеквизитФормы(
		"Свойство", Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения"),
			ИмяОписания));
			
	Реквизиты.Добавить(Новый РеквизитФормы(
		"Наименование", Новый ОписаниеТипов("Строка"), ИмяОписания));
	
	Реквизиты.Добавить(Новый РеквизитФормы(
		"ИмяПоля", Новый ОписаниеТипов("Строка"), ИмяОписания));
		
	Реквизиты.Добавить(Новый РеквизитФормы(
		"ТипЗначения", Новый ОписаниеТипов("ОписаниеТипов"), ИмяОписания));
			
	Реквизиты.Добавить(Новый РеквизитФормы(
		"ЗаполнятьОбязательно", Новый ОписаниеТипов("Булево"), ИмяОписания));
		
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПоляРасширенногоРеквизита(Элемент)
	
	ПриИзмененииПоляРасширенногоРеквизитаНаСервере(Элемент.Имя);		
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииПоляРасширенногоРеквизитаНаСервере(ИмяПоля)
	
	ЧистыйМассив = Новый Массив;
	
	МассивЗначений = ЭтаФорма[ИмяПоля].ВыгрузитьЗначения();
	Для Каждого текЗначение Из МассивЗначений Цикл		
		Если ЧистыйМассив.Найти(текЗначение) = Неопределено Тогда
			Если ЗначениеЗаполнено(текЗначение) Тогда
				ЧистыйМассив.Добавить(текЗначение);
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;
	
	ЭтаФорма[ИмяПоля].ЗагрузитьЗначения( ЧистыйМассив );
	
КонецПроцедуры

&НаСервере
Функция ПолучитьИмяРеквизитаФормы(НазваниеДопРеквизита, Форма) // 2018-03
            
    ИмяРеквизита = "";
    МассивРеквизитов = Форма.Свойства_ОписаниеДополнительныхРеквизитов.НайтиСтроки(Новый Структура("Наименование", НазваниеДопРеквизита));            
    Если МассивРеквизитов.Количество() > 0 Тогда
    	ИмяРеквизита = МассивРеквизитов[0].ИмяРеквизитаЗначение;
    КонецЕсли;
    Возврат ИмяРеквизита;
            
КонецФункции

&НаСервере
Процедура ПереносПолейКарточкиКонтрагента() // 2018-03
	
	// Перемещение объектов в карточке контрагента 
	Страница = Элементы.Страницы.ПодчиненныеЭлементы.Найти("ГруппаИсторияВзаимодействия");
	ПоляСтраницы = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаДополнительныеРеквизиты
		.ПодчиненныеЭлементы[0].ПодчиненныеЭлементы;
		
	// Важно! Если испольцовать цикл, то счётчик проскакивает на 1 после перемещения поля
	СвойствоЭлемент = ПоляСтраницы.Найти(
		ПолучитьИмяРеквизитаФормы("Источник информации", ЭтаФорма));
	Элементы.Переместить(СвойствоЭлемент, Страница, Страница.ПодчиненныеЭлементы.Найти("ИсторияВзаимодействия"));
	СвойствоЭлемент = ПоляСтраницы.Найти(
		ПолучитьИмяРеквизитаФормы("Дополнительная информация об источнике", ЭтаФорма));
	Элементы.Переместить(СвойствоЭлемент, Страница, Страница.ПодчиненныеЭлементы.Найти("ИсторияВзаимодействия"));

КонецПроцедуры



&НаСервере
Процедура РасшДОАМ_ПриСозданииНаСервереПеред(Отказ, СтандартнаяОбработка)
	
	//Есть = УправлениеДоступом.ЕстьПравоПоЗначениюДоступа("Редактирование", Объект.Ссылка, ПараметрыСеанса.ТекущийПользователь);
		
	ПодразделениеОтветственного = Объект.Ответственный.Подразделение;
	Пользователь = ПараметрыСеанса.ТекущийПользователь;
		
	//// DOAM 2019-07-04 {
		ПроверкаПросмотраКонтрагентов = ПравоДоступа("Просмотр", Метаданные.Справочники.Контрагенты);
		
		Если РольДоступна(Метаданные.Роли.РаботаСЗадачамиСотрудниковПодразделения)
		И ПроверкаПросмотраКонтрагентов = Истина Тогда
			ПроверкаПросмотраКонтрагентов = Истина;
		Иначе
			ПроверкаПросмотраКонтрагентов = Ложь;
		КонецЕсли;
		
		//Делегирование, проверка по списку (назначает Администратор)
		Если ДокументооборотПраваДоступаПереопределяемый.ЭтоДелегат(Пользователь, Истина) Тогда //// 2019-07-04
			ПроверкаДелегата = Ложь;
			СписокДелегатов = Справочники.ДелегированиеПрав.СписокДелегирующих(Пользователь);
			
			Для Каждого ЭтоДелегат Из СписокДелегатов Цикл
				Если ЭтоДелегат = Объект.Ответственный Тогда
					ПроверкаДелегата = Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		//Сообщить(ПроверкаПросмотраКонтрагентов);
	//// } DOAM 
	
	Если НЕ Объект.Ссылка.Пустая() Тогда
		// //только если объект не новый
		
		//Если РольДоступна(Метаданные.Роли.ПолныеПрава) Тогда
			//Сообщить(Пользователь.Ссылка.Наименование + " имеет Полные Права!"); // Администратор
				
		Если Пользователь.Подразделение.Наименование = ""
			ИЛИ ПодразделениеОтветственного.Руководитель = Пользователь
			И ПроверкаПросмотраКонтрагентов
			ИЛИ Объект.Ответственный = Пользователь
			ИЛИ Объект.Ответственный = ЭтоДелегат И ПроверкаДелегата Тогда //// 2019-07-04
			
			//Сообщить(Пользователь.Ссылка.Наименование + " имеет Права доступа!"); // Пользователь
			
		Иначе			
			Если ПустаяСтрока(ПодразделениеОтветственного.Наименование) Тогда
		    	ПараметрСообщения = "Администратора системы";
			Иначе
				ПараметрСообщения = "Руководителя подразделения " + ПодразделениеОтветственного;
			КонецЕсли;
			
			Сообщить("Доступ к карточке контрагента «" + Объект.Наименование + "» возможен через " + ПараметрСообщения);
			Отказ = Истина;
			Возврат;
						
		КонецЕсли;
		// Перезаписывается только при "Записи" данных пользователя, но не при изменении Структуры предприятия
		//Сообщить(ПодразделениеОтветственного.Руководитель);
	КонецЕсли;
	
	// страница для расширенных реквизитов
	Страница 			= Элементы.Добавить("ГруппаРасширения", Тип("ГруппаФормы"), Элементы.Страницы);	
	Страница.Вид 		= ВидГруппыФормы.Страница;	
	Страница.Заголовок 	= "Расширенные реквизиты";
	
	Реквизиты 	= Новый Массив;
	
	РасшДОАМ_СоздатьТаблицуОписанияРасширенныхРеквизитов(Реквизиты);	
	
	// добавляются реквизиты формы	
	ТЗРеквизиты = ОбщийДОАМ.РасшДОАМ_ПолучитьРасширенныеРеквизиты();
	Для Каждого текРеквизит Из ТЗРеквизиты Цикл 
		ИмяПоля 	= текРеквизит.ИмяПоля; 		
		Реквизит 	= Новый РеквизитФормы(ИмяПоля, Новый ОписаниеТипов("СписокЗначений"),,текРеквизит.Наименование);	
		Реквизиты.Добавить(Реквизит);
	КонецЦикла;
	
	ЭтаФорма.ИзменитьРеквизиты(Реквизиты);
	
	ТЗРасширенныхРеквизитов = ЭтаФорма.ТаблицаОписанияРасширенныхРеквизитов;
	
	// создаются поля на форме
	Для Каждого текРеквизит Из ТЗРеквизиты Цикл
		                      
		ИмяПоля 			= текРеквизит.ИмяПоля;
		СвойствоРеквизит 	= текРеквизит.Свойство;
		ТипЗначения			= текРеквизит.ТипЗначения;
	    ЗаголовокРеквизита	= текРеквизит.Наименование;
		
		ЭтаФорма[ИмяПоля].ТипЗначения  	= ТипЗначения; // Новый ОписаниеТипов("СправочникСсылка.ЗначенияСвойствОбъектовИерархия"); или 	Новый ОписаниеТипов("СправочникСсылка.ЗначенияСвойствОбъектов");
		НовыйЭлемент 							= Элементы.Вставить(ИмяПоля, Тип("ПолеФормы"), Страница);
		НовыйЭлемент.Вид						= ВидПоляФормы.ПолеВвода;
		НовыйЭлемент.ПутьКДанным				= ИмяПоля;
		НовыйЭлемент.Заголовок					= ЗаголовокРеквизита;
		НовыйЭлемент.АвтоОтметкаНезаполненного  = текРеквизит.ЗаполнятьОбязательно;
		НовыйЭлемент.УстановитьДействие("ПриИзменении", "ПриИзмененииПоляРасширенногоРеквизита");
		
		// установить параметры выбора, чтобы при выборе в списке отображался только нужный тип данных
		ПараметрСвойство						= Новый ПараметрВыбора("Отбор.Владелец", СвойствоРеквизит);
		МассивПараметров						= Новый Массив();
		МассивПараметров.Добавить(ПараметрСвойство);
		ФиксМассПараметров						= Новый ФиксированныйМассив(МассивПараметров);
		НовыйЭлемент.ПараметрыВыбора			= ФиксМассПараметров; 
	
		// загрузка значений в реквизиты формы из регистра
		ТЗ = Объект.РасширенныеРеквизиты.Выгрузить(Новый Структура("Свойство", СвойствоРеквизит), "Значение");
		МассивЗначений = ТЗ.ВыгрузитьКолонку("Значение"); 
		ЭтаФорма[ИмяПоля].ЗагрузитьЗначения( МассивЗначений );
		
		НоваяСтрока = ТЗРасширенныхРеквизитов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, текРеквизит);
		
	КонецЦикла;
		
	// Перемещение вкладки в карточке контрагента // 2018-03
	Страница = Элементы.Страницы.ПодчиненныеЭлементы.Найти("ГруппаИсторияВзаимодействия");
	Элементы.Переместить(Страница, Элементы.Страницы); 
		
КонецПроцедуры

&НаКлиенте
Процедура РасшДОАМ_ПриОткрытииПосле(Отказ)
	
	ПереносПолейКарточкиКонтрагента(); // ПЕРЕНОС ПОЛЕЙ 2018-03

КонецПроцедуры

&НаСервере
Процедура РасшДОАМ_ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// требуется сохранить все значения расширенных реквизитов	
	ТЗРасширенныхРеквизитов = ЭтаФорма.ТаблицаОписанияРасширенныхРеквизитов;
	Объект.РасширенныеРеквизиты.Очистить();
	ТЗ = Объект.РасширенныеРеквизиты.Выгрузить().СкопироватьКолонки();
	Для Каждого текРеквизит Из ТЗРасширенныхРеквизитов Цикл
		
		ИмяПоля 			= текРеквизит.ИмяПоля;
		СвойствоРеквизит 	= текРеквизит.Свойство;
		
		МассивЗначений 		= ЭтаФорма[ИмяПоля].ВыгрузитьЗначения();
		Для Каждого текЗначение Из МассивЗначений Цикл
		    НоваяСтрока = ТЗ.Добавить();
			НоваяСтрока.Свойство = СвойствоРеквизит;
			НоваяСтрока.Значение = текЗначение;
		КонецЦикла;
	
	КонецЦикла;
	ТекущийОбъект.РасширенныеРеквизиты.Загрузить(ТЗ);
	
	ДатаПоследняя = Дата(1,1,1);
	Если Объект.ИсторияВзаимодействия.Количество() > 0 Тогда
		ТЗИстория = Объект.ИсторияВзаимодействия.Выгрузить(,"Дата");
		ТЗИстория.Сортировать("Дата Убыв");
		ДатаПоследняя = ТЗИстория[0].Дата;
	КонецЕсли;

	ТекущийОбъект.ДатаПоследняя = ДатаПоследняя;

КонецПроцедуры


&НаСервере
// проверяется заполненность обязательных полей расширенных реквизитов 
// (для обычных доп реквизитов это уже реализовано в стандартном модуле)
Процедура РасшДОАМ_ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ТЗРасширенные = ЭтаФорма.ТаблицаОписанияРасширенныхРеквизитов;
	Для Каждого текРеквизит Из ТЗРасширенные Цикл 		

		Если Элементы[текРеквизит.ИмяПоля].ОтметкаНезаполненного Тогда
	    	Сообщить("Поле: """ + текРеквизит.Наименование + """ не заполнено");
			Отказ = Истина;
		КонецЕсли;
	
	КонецЦикла;
					
КонецПроцедуры

&НаКлиенте
Процедура РасшДОАМ_ЮрФизЛицоПриИзмененииПосле(Элемент)
	
	ПереносПолейКарточкиКонтрагента(); // ПЕРЕНОС ПОЛЕЙ 2018-03
	
КонецПроцедуры
