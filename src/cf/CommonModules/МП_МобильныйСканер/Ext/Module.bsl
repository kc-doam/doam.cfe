﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа со сканером документов". Серверная часть.
//
// Модуль для работы с мобильным сканером, который загружает отсканированное в открытую карточку документа.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Снимает блокировку регистра МП_Сканы для указанной формы.
//
// Параметры:
//  Идентификатор - УникальныйИдентификатор - Идентификатор формы, для которой нужно снять блокировку.
//
Процедура ОсвободитьСканер(Идентификатор) Экспорт
	
	Отбор = Новый Структура;
	Отбор.Вставить("Пользователь", Пользователи.ТекущийПользователь());
	Ключ = РегистрыСведений.МП_Сканы.СоздатьКлючЗаписи(Отбор);
	РазблокироватьДанныеДляРедактирования(Ключ, Идентификатор);
	
КонецПроцедуры

// Делает попытку блокировки регистра МП_Сканы для указанной формы.
//
// Параметры:
//  Идентификатор - УникальныйИдентификатор - Идентификатор формы, для которой нужно установить блокировку.
//
// Возвращаемое значение:
//  Булево - Истина в случае успеха, Ложь в случае неудачи.
//
Функция ЗанятьСканер(Идентификатор) Экспорт
	
	Пользователь = Пользователи.ТекущийПользователь();
	Отбор = Новый Структура;
	Отбор.Вставить("Пользователь", Пользователь);
	Ключ = РегистрыСведений.МП_Сканы.СоздатьКлючЗаписи(Отбор);
	Попытка
		ЗаблокироватьДанныеДляРедактирования(Ключ,, Идентификатор);
		РегистрыСведений.МП_Сканы.УдалитьСкан(Пользователь);
		
		Возврат Истина;
		
	Исключение
		
		Возврат Ложь;
		
	КонецПопытки;
	
КонецФункции

// Загружает в регистр СканыСМобильногоСканера скан с мобильного
//
// Параметры:
//  Скан - ДвоичныеДанные - Двоичные данные скана
//
// Возвращааемое значение:
//  Возвращает строку, которая может принимать следующие значения:
//   "СканЗагружен"                        - Если скан успешно загружен в регистр
//   "НеНайденаФорма"                      - Если нет формы, занявшей сканер
//   "ВыполняетсяЗагрузкаПредыдущегоСкана" - Если предыдущий скан еще не загрузился
//
Функция ЗагрузитьСкан(Скан) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	Пользователь = Пользователи.ТекущийПользователь();
	
	Отбор = Новый Структура;
	Отбор.Вставить("Пользователь", Пользователь);
	Ключ = РегистрыСведений.МП_Сканы.СоздатьКлючЗаписи(Отбор);
	Идентификатор = Новый УникальныйИдентификатор();
	Попытка
		//Если удалось заблокировать регистр, значит нет формы, ожидающей скан
		ЗаблокироватьДанныеДляРедактирования(Ключ,,Идентификатор);
		//Разблокируем, иначе формы на настольном не смогут занять сканер
		РазблокироватьДанныеДляРедактирования(Ключ, Идентификатор);
		Возврат "НеНайденаФорма";

	Исключение
		Если СканЗагружен() Тогда
			
			Возврат "ВыполняетсяЗагрузкаПредыдущегоСкана";
			
		КонецЕсли;
		РегистрыСведений.МП_Сканы.ДобавитьСкан(Пользователь, Скан);
		
		Возврат "СканЗагружен";

	КонецПопытки;
	
КонецФункции

// Создает файл в карточке документа по двоичным данным в регистре МП_Сканы.
// После этого очищает регистр.
//
// Параметры:
//  Владелец - Ссылка на объект, который будет установлен владельцем файла.
//  ИмяФайла - Строка - Будущее имя файла.
//
// Возвращаемое значение:
//  Структура
//   * ФайлДобавлен - Булево
//   * ФайлСсылка - Строка
//   * ТекстОшибки - Строка
//
Функция ОбработатьСкан(Владелец, ИмяФайла) Экспорт
	
	Пользователь = Пользователи.ТекущийПользователь();
	Результат = Новый Структура;
	Результат.Вставить("ФайлДобавлен", Ложь);
	Результат.Вставить("ФайлСсылка",   Неопределено);
	Результат.Вставить("ТекстОшибки",  "");
	
	Скан = РегистрыСведений.МП_Сканы.ПолучитьСкан(Пользователь);Идентификатор = Новый УникальныйИдентификатор();
	
	Если Не ЗначениеЗаполнено(Скан) Тогда
		Результат.ТекстОшибки = НСтр("ru='Скан отсутствует в регистре'");
		Возврат Результат;
	КонецЕсли;
	
	Идентификатор = Новый УникальныйИдентификатор();
	
	АдресВременногоХранилищаФайла = ПоместитьВоВременноеХранилище(Скан, Идентификатор);
	
	Попытка
		СведенияОФайле = РаботаСФайламиКлиентСервер.СведенияОФайле("ФайлСВерсией");
		СведенияОФайле.АдресВременногоХранилищаФайла = АдресВременногоХранилищаФайла;
		СведенияОФайле.ЗаписатьВИсторию = Истина;
		СведенияОФайле.ИмяБезРасширения = ИмяФайла;
		СведенияОФайле.РасширениеБезТочки = "jpg";
		СведенияОФайле.ВремяИзменения = ТекущаяДатаСеанса();
		СведенияОФайле.ВремяИзмененияУниверсальное = РаботаСФайламиКлиентСервер.ПолучитьУниверсальноеВремя(
			СведенияОФайле.ВремяИзменения);
		СведенияОФайле.Размер = Скан.Размер();
		
		Результат.ФайлСсылка = РаботаСФайламиВызовСервера.СоздатьФайлСВерсией(Владелец, СведенияОФайле);
		Результат.ФайлДобавлен = Истина;
	Исключение
		Результат.ТекстОшибки = ФайловыеФункцииСлужебныйКлиентСервер.ОшибкаСозданияНовогоФайла(
			ИнформацияОбОшибке());
	КонецПопытки;
	
	УдалитьИзВременногоХранилища(СведенияОФайле.АдресВременногоХранилищаФайла);
	РегистрыСведений.МП_Сканы.УдалитьСкан(Пользователи.ТекущийПользователь());

	Возврат Результат;
	
КонецФункции

// Проверяет есть ли запись со сканом в регистре МП_Сканы.
//
// Возвращаемое значение:
//  Булево - Истина, если скан есть, Ложь если записи нет.
//
Функция СканЗагружен() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	МП_Сканы.Пользователь КАК Пользователь
		|ИЗ
		|	РегистрСведений.МП_Сканы КАК МП_Сканы
		|ГДЕ
		|	МП_Сканы.Пользователь = &Пользователь";
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти
