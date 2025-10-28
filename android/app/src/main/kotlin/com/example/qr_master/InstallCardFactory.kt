package com.example.qr_master

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class InstallCardFactory(private val context: Context) : GoogleMobileAdsPlugin.NativeAdFactory {

    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val inflater = LayoutInflater.from(context)
        val adView = inflater.inflate(R.layout.native_install_card, null) as NativeAdView

        // Referencias a las subviews
        val headline = adView.findViewById<TextView>(R.id.headline)
        val body = adView.findViewById<TextView>(R.id.body)
        val icon = adView.findViewById<ImageView>(R.id.app_icon)
        val cta = adView.findViewById<Button>(R.id.cta)
        val rating = adView.findViewById<RatingBar>(R.id.rating_bar)
        val mediaView = adView.findViewById<com.google.android.gms.ads.nativead.MediaView>(R.id.media)

        // Mapa de vistas obligatorias
        adView.headlineView = headline
        adView.bodyView = body
        adView.iconView = icon
        adView.callToActionView = cta
        adView.starRatingView = rating
        adView.mediaView = mediaView

        // Asignar datos
        headline.text = nativeAd.headline
        body.text = nativeAd.body
        cta.text = nativeAd.callToAction

        nativeAd.icon?.let { icon.setImageDrawable(it.drawable) }
        nativeAd.mediaContent?.let { mediaView.mediaContent = it }

        // Rating opcional
        val stars = nativeAd.starRating
        if (stars != null) {
            rating.visibility = View.VISIBLE
            rating.rating = stars.toFloat()
        } else {
            rating.visibility = View.GONE
        }

        adView.setNativeAd(nativeAd)
        return adView
    }
}
