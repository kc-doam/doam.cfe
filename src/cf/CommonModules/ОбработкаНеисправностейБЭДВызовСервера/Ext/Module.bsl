﻿
#Область СлужебныйПрограммныйИнтерфейс

// См. ОбработкаНеисправностейБЭД.ОбработатьОшибку
Процедура ОбработатьОшибку(ВидОперации, Подсистема, ТекстОшибкиДляЖурналаРегистрации, ТекстОшибкиДляПользователя = "",
	СсылкаНаОбъект = Неопределено) Экспорт
	
	ОбработкаНеисправностейБЭД.ОбработатьОшибку(ВидОперации, Подсистема, ТекстОшибкиДляЖурналаРегистрации,
		ТекстОшибкиДляПользователя, СсылкаНаОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НачатьПолучениеФайлаДляТехПоддержки(КонтекстДиагностики, ТехническаяИнформация) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Получение файла для тех.поддержки'");
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения,
		"ОбработкаНеисправностейБЭД.АрхивСИнформациейДляТехПоддержки", КонтекстДиагностики, ТехническаяИнформация);
	
КонецФункции

#КонецОбласти

