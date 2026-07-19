import { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, Alert, ActivityIndicator, KeyboardAvoidingView, Platform, ScrollView } from 'react-native';
import { router } from 'expo-router';

export default function LoginScreen() {
  const [phone, setPhone] = useState('');
  const [pin, setPin] = useState('');
  const [loading, setLoading] = useState(false);

  const handleLogin = async () => {
    if (!phone.startsWith('01') || phone.length !== 11) {
      Alert.alert('خطأ', 'رقم الموبايل غير صحيح. لازم يبدأ بـ 01 ويكون 11 رقم');
      return;
    }
    if (!pin || pin.length < 4) {
      Alert.alert('خطأ', 'ادخل الرقم السري للمحفظة (4 أرقام على الأقل)');
      return;
    }

    setLoading(true);
    try {
      const seamlessRes = await fetch(
        'http://mobile.vodafone.com.eg/checkSeamless/realms/vf-realm/protocol/openid-connect/auth?client_id=ana-vodafone-app-seamless',
        {
          method: 'GET',
          headers: {
            'User-Agent': 'okhttp/4.11.0',
            'Connection': 'Keep-Alive',
            'Accept-Encoding': 'gzip',
            'x-agent-operatingsystem': '13',
            'clientId': 'AnaVodafoneAndroid',
            'Accept-Language': 'ar',
            'x-agent-device': 'OPPO CPH2235',
            'x-agent-version': '2024.7.2.1',
            'x-agent-build': '1050',
            'digitalId': '24S0M31T0I9RK',
          },
        }
      );
      const seamlessData = await seamlessRes.json();
      const seamlessToken = seamlessData.seamlessToken;
      const msisdn = seamlessData.msisdn;

      if (!seamlessToken) {
        Alert.alert('خطأ', 'فشل تسجيل الدخول. تأكد إنك متصل بشبكة فودافون (بيانات الموبايل)');
        setLoading(false);
        return;
      }

      const tokenRes = await fetch(
        'https://mobile.vodafone.com.eg/auth/realms/vf-realm/protocol/openid-connect/token',
        {
          method: 'POST',
          headers: {
            'User-Agent': 'okhttp/4.11.0',
            'Accept': 'application/json, text/plain, */*',
            'Accept-Encoding': 'gzip',
            'silentLogin': 'true',
            'seamlessToken': seamlessToken,
            'firstTimeLogin': 'true',
            'x-agent-operatingsystem': '13',
            'clientId': 'AnaVodafoneAndroid',
            'Accept-Language': 'ar',
            'x-agent-device': 'OPPO CPH2235',
            'x-agent-version': '2024.7.2.1',
            'x-agent-build': '1050',
            'digitalId': '24S0M31T0I9RK',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: 'grant_type=password&client_secret=b86e30a8-ae29-467a-a71f-65c73f2ff5e3&client_id=cash-app',
        }
      );
      const tokenData = await tokenRes.json();
      const accessToken = tokenData.access_token;

      if (!accessToken) {
        Alert.alert('خطأ', 'فشل الحصول على التوكن');
        setLoading(false);
        return;
      }

      router.push({
        pathname: '/cards',
        params: { accessToken, msisdn, pin },
      });
    } catch (_err) {
      Alert.alert('خطأ', 'فشل الاتصال. تأكد إنك متصل بشبكة فودافون (بيانات الموبايل مش WiFi)');
    } finally {
      setLoading(false);
    }
  };

  return (
    <KeyboardAvoidingView behavior={Platform.OS === 'ios' ? 'padding' : 'height'} className="flex-1">
      <ScrollView contentContainerStyle={{ flexGrow: 1 }} keyboardShouldPersistTaps="handled">
        <View className="flex-1 bg-white justify-center px-6">
          <View className="items-center mb-10">
            <Text className="text-4xl font-bold text-red-600">Cards Fakka</Text>
            <Text className="text-base text-gray-500 mt-2">Mr.Eslam Hacker</Text>
          </View>

          <View className="bg-red-50 rounded-2xl p-6">
            <Text className="text-xl font-bold text-gray-800 text-center mb-6">تسجيل الدخول</Text>

            <View className="mb-4">
              <Text className="text-sm font-semibold text-gray-700 mb-2">📱 رقم الموبايل</Text>
              <TextInput
                className="bg-white border border-gray-200 rounded-xl px-4 py-3 text-base text-gray-800"
                placeholder="01xxxxxxxxx"
                placeholderTextColor="#9ca3af"
                keyboardType="phone-pad"
                maxLength={11}
                value={phone}
                onChangeText={setPhone}
              />
            </View>

            <View className="mb-6">
              <Text className="text-sm font-semibold text-gray-700 mb-2">🔒 الرقم السري للمحفظة</Text>
              <TextInput
                className="bg-white border border-gray-200 rounded-xl px-4 py-3 text-base text-gray-800"
                placeholder="****"
                placeholderTextColor="#9ca3af"
                keyboardType="number-pad"
                secureTextEntry
                maxLength={6}
                value={pin}
                onChangeText={setPin}
              />
            </View>

            <TouchableOpacity
              className={`rounded-xl py-4 items-center ${loading ? 'bg-red-300' : 'bg-red-600'}`}
              onPress={handleLogin}
              disabled={loading}
              activeOpacity={0.8}
            >
              {loading ? <ActivityIndicator color="#fff" /> : <Text className="text-white font-bold text-base">دخول</Text>}
            </TouchableOpacity>
          </View>

          <View className="mt-6 bg-yellow-50 rounded-xl p-4">
            <Text className="text-xs text-yellow-700 text-center leading-5">
              ⚠️ لازم تكون متصل بشبكة فودافون (بيانات الموبايل) عشان التطبيق يشتغل. مش هيشتغل على WiFi.
            </Text>
          </View>

          <TouchableOpacity className="mt-6 items-center">
            <View className="bg-gray-900 border border-cyan-500 rounded-full px-6 py-3">
              <Text className="text-cyan-400 text-sm text-center">📢 اشترك في قناة التليجرام</Text>
              <Text className="text-cyan-600 text-xs text-center mt-1">@ESIAM_HACKER</Text>
            </View>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
    }
