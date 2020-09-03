package com.yl.flutter_lbs;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Build;
import android.telephony.TelephonyManager;
import android.telephony.cdma.CdmaCellLocation;
import android.telephony.gsm.GsmCellLocation;
import android.util.Log;

import java.util.Locale;

import androidx.annotation.NonNull;

import androidx.annotation.RequiresApi;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterLbsPlugin */
public class FlutterLbsPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context mContext;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_lbs");
    mContext = flutterPluginBinding.getApplicationContext();
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + Build.VERSION.RELEASE);
    }
    else if (call.method.equals("getLbsInfo")) {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ECLAIR) {
        result.success(getCellInfo());
      }
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  /**
   * 获取基站信息
   */

//  @android.support.annotation.RequiresApi(api = Build.VERSION_CODES.ECLAIR)
  @RequiresApi(api = Build.VERSION_CODES.ECLAIR)
  @SuppressLint("MissingPermission")
  private String getCellInfo() {


    StationInfo stationInfo = new StationInfo();

    /** 调用API获取基站信息 */
    TelephonyManager telephonyManager = (TelephonyManager) mContext.getSystemService(Context.TELEPHONY_SERVICE);

//        if (!hasSimCard(mContext)){ //判断有没有sim卡，如果没有安装sim卡下面则会异常
//            Toast.makeText(mContext,"请安装sim卡",Toast.LENGTH_LONG).show();
//            return null;
//        }
    String operator = telephonyManager.getNetworkOperator();
    Log.e("operator", "operator=" + operator);
    int mcc = Integer.parseInt(operator.substring(0, 3));
    int mnc = Integer.parseInt(operator.substring(3));

    int cid = 0;
    int lac = 0;
    if (mnc == 11 || mnc == 03 || mnc == 05) {  //03 05 11 为电信CDMA
      CdmaCellLocation location = (CdmaCellLocation) telephonyManager.getCellLocation();
      //这里的值可根据接口需要的参数获取
      cid = location.getBaseStationId();
      lac = location.getNetworkId();
      mnc = location.getSystemId();
    } else {
      GsmCellLocation location = (GsmCellLocation) telephonyManager.getCellLocation();
      cid = location.getCid();
      lac = location.getLac();
    }

    /** 将获得的数据放到结构体中 */
    stationInfo.setMCC(mcc);
    stationInfo.setMNC(mnc);
    stationInfo.setLAC(lac);
    stationInfo.setCID(cid);

    String info = String.format(Locale.CHINA, "{\"CID\":%s,\"LAC\":%s,\"MCC\":%s,\"MNC\":%s}",
            stationInfo.getCID(), stationInfo.getLAC(), stationInfo.getMCC(), stationInfo.getMNC());
    Log.e("getCellInfo: ",info);
    return info;

  }

  class StationInfo{
    private int MCC;
    private int MNC;
    private int LAC;
    private int CID;

    public int getMCC() {
      return MCC;
    }

    public void setMCC(int MCC) {
      this.MCC = MCC;
    }

    public int getMNC() {
      return MNC;
    }

    public void setMNC(int MNC) {
      this.MNC = MNC;
    }

    public int getLAC() {
      return LAC;
    }

    public void setLAC(int LAC) {
      this.LAC = LAC;
    }

    public int getCID() {
      return CID;
    }

    public void setCID(int CID) {
      this.CID = CID;
    }



  }

}
