import { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, ScrollView, Alert, ActivityIndicator, FlatList } from 'react-native';
import { useLocalSearchParams, router } from 'expo-router';

interface CardItem {
  name: string;
  id: string;
  price: string;
  category: 'fakka' | 'mared';
  icon: string;
}

const FAKKA_PRODUCTS: CardItem[] = [
  { name: 'فكة 2.5 جنيه', id: 'Fakka_2.5_Unite', price: '2.5', category: 'fakka', icon: '💰' },
  { name: 'فكة 4.25 جنيه', id: 'Fakka_4.25_Unite', price: '4.25', category: 'fakka', icon: '💰' },
  { name: 'فكة 5 جنيه', id: 'Fakka_5_Unite', price: '5', category: 'fakka', icon: '💰' },
  { name: 'فكة 6 جنيه', id: 'Fakka_6_NewUnite', price: '6', category: 'fakka', icon: '💰' },
  { name: 'فكة 7 جنيه', id: 'Fakka_7_Unite', price: '7', category: 'fakka', icon: '💰' },
  { name: 'فكة 9 جنيه', id: 'Fakka_9_Unite', price: '9', category: 'fakka', icon: '💰' },
  { name: 'فكة 10 جنيه', id: 'Fakka_10_Unite', price: '10', category: 'fakka', icon: '💰' },
  { name: 'فكة 10 جنيه (new)', id: 'Fakka_10_NewUnite', price: '10', category: 'fakka', icon: '✨' },
  { name: 'فكة 10.5 جنيه', id: 'Fakka_10.5_Unite', price: '10.5', category: 'fakka', icon: '💰' },
  { name: 'فكة 11.5 جنيه', id: 'Fakka_11.5_Unite', price: '11.5', category: 'fakka', icon: '💰' },
  { name: 'فكة 12 جنيه', id: 'Fakka_12_Unite', price: '12', category: 'fakka', icon: '💰' },
  { name: 'فكة 12.5 جنيه', id: 'Fakka_12.5_Unite', price: '12.5', category: 'fakka', icon: '💰' },
  { name: 'فكة 13 جنيه', id: 'Fakka_13_Unite', price: '13', category: 'fakka', icon: '💰' },
  { name: 'فكة 13.5 جنيه', id: 'Fakka_13.5_Unite', price: '13.5', category: 'fakka', icon: '💰' },
  { name: 'فكة 15 جنيه', id: 'Fakka_15_Unite', price: '15', category: 'fakka', icon: '💰' },
  { name: 'فكة 15 جنيه (new)', id: 'Fakka_15_NewUnite', price: '15', category: 'fakka', icon: '✨' },
  { name: 'فكة 15.5 جنيه', id: 'Fakka_15.5_Unite', price: '15.5', category: 'fakka', icon: '💰' },
  { name: 'فكة 16.5 جنيه', id: 'Fakka_16.5_Unite', price: '16.5', category: 'fakka', icon: '💰' },
  { name: 'فكة 17.5 جنيه', id: 'Fakka_17.5_Unite', price: '17.5', category: 'fakka', icon: '💰' },
  { name: 'فكة 19.5 جنيه', id: 'Fakka_19.5_NewUnite', price: '19.5', category: 'fakka', icon: '💰' },
  { name: 'فكة 20 جنيه', id: 'Fakka_20_Unite', price: '20', category: 'fakka', icon: '💰' },
  { name: 'فكة 26 جنيه', id: 'Fakka_26_Unite', price: '26', category: 'fakka', icon: '💰' },
];

const MARED_PRODUCTS: CardItem[] = [
  { name: 'مارد 10 دقايق', id: 'Mared_10_Minuts', price: '10', category: 'mared', icon: '📞' },
  { name: 'مارد 10 فليكس', id: 'Mared_10_Flexs', price: '10', category: 'mared', icon: '⚡' },
  { name: 'مارد 10 سوشيال', id: 'Mared_10_Social', price: '10', category: 'mared', icon: '📱' },
];

function ReceiverInput({ value, onChange }: { value: string; onChange: (text: string) => void }) {
  return (
    <TextInput
      className="text-base text-gray-800"
      placeholder="01xxxxxxxxx"
      placeholderTextColor="#9ca3af"
      keyboardType="phone-pad"
      maxLength={11}
      value={value}
      onChangeText={onChange}
    />
  );
}

export default function CardsScreen() {
  const { accessToken, msisdn, pin } = useLocalSearchParams<{
    accessToken: string;
    msisdn: string;
    pin: string;
  }>();

  const [loadingCard, setLoadingCard] = useState<string | null>(null);
  const [receiver, setReceiver] = useState('');
  const [selectedCard, setSelectedCard] = useState<CardItem | null>(null);
  const [showReceiverInput, setShowReceiverInput] = useState(false);

  const purchaseCard = async (card: CardItem, targetNumber: string) => {
    if (!targetNumber || !targetNumber.startsWith('01') || targetNumber.length !== 11) {
      Alert.alert('خطأ', 'ادخل رقم صحيح يبدأ بـ 01 ويكون 11 رقم');
      return;
    }

    setLoadingCard(card.id);

    try {
      const senderMsisdn = msisdn?.startsWith('0') ? msisdn : `0${msisdn}`;

      const payload = {
        channel: { name: 'MobileApp' },
        orderItem: [
          {
            action: 'insert',
            id: card.id,
            product: {
              characteristic: [
                { name: 'PaymentMethod', value: 'VFCash' },
                { name: 'USE_EMONEY', value: 'False' },
                { name: 'MerchantCode', value: '' },
              ],
              id: card.id,
              relatedParty: [
                { id: msisdn, name: 'MSISDN', role: 'Subscriber' },
                { id: targetNumber, name: 'Receiver', role: 'Receiver' },
              ],
            },
            '@type': card.id,
            eCode: 0,
          },
        ],
        relatedParty: [
          { id: pin, name: 'pin', role: 'Requestor' },
        ],
        '@type': 'CashFakkaAndMared',
      };

      const response = await fetch(
        'https://mobile.vodafone.com.eg/services/dxl/pom/productOrder',
        {
          method: 'POST',
          headers: {
            'User-Agent': 'okhttp/4.11.0',
            'Connection': 'Keep-Alive',
            'Accept': 'application/json',
            'Accept-Encoding': 'gzip',
            'Content-Type': 'application/json',
            'api-host': 'ProductOrderingManagement',
            'useCase': 'CashFakkaAndMared',
            'api-version': 'v2',
            'msisdn': senderMsisdn,
            'Authorization': `Bearer ${accessToken}`,
            'Accept-Language': 'ar',
            'x-agent-operatingsystem': '13',
            'clientId': 'AnaVodafoneAndroid',
            'x-agent-device': 'OPPO CPH2235',
            'x-agent-version': '2024.7.2.1',
            'x-agent-build': '1050',
            'digitalId': '24S0M31T0I9RK',
          },
          body: JSON.stringify(payload),
        }
      );

      const result = await response.json();

      if (result.state === 'Completed' || result.complete) {
        Alert.alert('✅ نجاح', `تم شحن ${card.name} للرقم ${targetNumber} بنجاح!`);
      } else {
        Alert.alert('❌ فشل', 'رصيدك غير كافي أو حدث خطأ آخر');
      }
    } catch (_err) {
      Alert.alert('❌ خطأ', 'فشل الاتصال بالسيرفر');
    } finally {
      setLoadingCard(null);
      setSelectedCard(null);
    }
  };

  const promptReceiver = (card: CardItem) => {
    setSelectedCard(card);
    setShowReceiverInput(true);
    setReceiver('');
  };

  const renderCard = ({ item }: { item: CardItem }) => (
    <View className="bg-white border border-gray-100 rounded-2xl p-4 mx-2 w-64 shadow-lg">
      <View className="bg-red-50 w-12 h-12 rounded-2xl items-center justify-center mb-3">
        <Text className="text-2xl">{item.icon}</Text>
      </View>
      <Text className="text-base font-bold text-gray-800 mb-1">{item.name}</Text>
      <Text className="text-2xl font-black text-red-600 my-2">
        {item.price} <Text className="text-xs font-normal text-gray-500">ج.م</Text>
      </Text>
      {item.category === 'mared' && (
        <View className="bg-blue-50 rounded-full px-3 py-1 self-start mb-2">
          <Text className="text-xs text-blue-600">
            {item.id.includes('Minuts') ? '📞 دقايق' : item.id.includes('Flexs') ? '⚡ فليكس' : '📱 سوشيال'}
          </Text>
        </View>
      )}
      <TouchableOpacity
        className={`rounded-xl py-3 items-center mt-2 ${loadingCard === item.id ? 'bg-red-300' : 'bg-red-600'}`}
        onPress={() => promptReceiver(item)}
        disabled={loadingCard === item.id}
        activeOpacity={0.8}
      >
        {loadingCard === item.id ? (
          <ActivityIndicator color="#fff" size="small" />
        ) : (
          <Text className="text-white font-bold text-sm">🛒 اشتر الآن</Text>
        )}
      </TouchableOpacity>
    </View>
  );

  return (
    <View className="flex-1 bg-white">
      <ScrollView className="flex-1" contentContainerStyle={{ paddingBottom: 40 }}>
        <View className="bg-red-600 pt-12 pb-6 px-5 rounded-b-3xl">
          <View className="flex-row items-center justify-between">
            <View>
              <Text className="text-white text-2xl font-bold">Cards Fakka</Text>
              <Text className="text-red-200 text-sm mt-1">مرحباً، {msisdn?.startsWith('0') ? msisdn : `0${msisdn}`}</Text>
            </View>
            <TouchableOpacity className="bg-white/20 rounded-xl px-4 py-2" onPress={() => router.back()}>
              <Text className="text-white font-bold text-sm">خروج</Text>
            </TouchableOpacity>
          </View>
        </View>

        <View className="mt-6 px-5">
          <Text className="text-xl font-bold text-gray-800 mb-4">🏷️ كروت الفكة</Text>
        </View>
        <FlatList
          data={FAKKA_PRODUCTS}
          renderItem={renderCard}
          keyExtractor={(item) => item.id}
          horizontal
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={{ paddingHorizontal: 12 }}
          scrollEnabled
        />

        <View className="mt-8 px-5">
          <Text className="text-xl font-bold text-gray-800 mb-4">🧞 كروت المارد</Text>
        </View>
        <FlatList
          data={MARED_PRODUCTS}
          renderItem={renderCard}
          keyExtractor={(item) => item.id}
          horizontal
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={{ paddingHorizontal: 12 }}
          scrollEnabled
        />

        <View className="mt-10 items-center px-5">
          <View className="bg-gray-900 border border-cyan-500 rounded-full px-6 py-3">
            <Text className="text-cyan-400 text-sm text-center">📢 اشترك في قناة التليجرام</Text>
            <Text className="text-cyan-600 text-xs text-center mt-1">@ESIAM_HACKER</Text>
          </View>
        </View>
      </ScrollView>

      {showReceiverInput && selectedCard && (
        <View className="absolute inset-0 bg-black/50 justify-center items-center px-6">
          <View className="bg-white rounded-2xl p-6 w-full max-w-sm">
            <Text className="text-lg font-bold text-gray-800 text-center mb-2">شراء {selectedCard.name}</Text>
            <Text className="text-sm text-gray-500 text-center mb-4">ادخل الرقم اللي عايز تشحن له</Text>
            <View className="bg-gray-50 border border-gray-200 rounded-xl px-4 py-3 mb-4">
              <ReceiverInput value={receiver} onChange={setReceiver} />
            </View>
            <View className="flex-row gap-3">
              <TouchableOpacity
                className="flex-1 bg-gray-200 rounded-xl py-3 items-center"
                onPress={() => { setShowReceiverInput(false); setSelectedCard(null); }}
              >
                <Text className="text-gray-700 font-bold">إلغاء</Text>
              </TouchableOpacity>
              <TouchableOpacity
                className={`flex-1 rounded-xl py-3 items-center ${loadingCard ? 'bg-red-300' : 'bg-red-600'}`}
                onPress={() => { setShowReceiverInput(false); purchaseCard(selectedCard, receiver); }}
                disabled={!!loadingCard}
              >
                {loadingCard ? <ActivityIndicator color="#fff" size="small" /> : <Text className="text-white font-bold">شحن</Text>}
              </TouchableOpacity>
            </View>
          </View>
        </View>
      )}
    </View>
  );
            }
