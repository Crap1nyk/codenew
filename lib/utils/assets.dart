enum MAssetImage {
  icon,
  banner,
  truck,
  phoneIcon,
  emailIcon,
  imageUploadIcon,
  scanIcon,
  pfdIcon,
  ctpatIcon,
}

class MAssets {
  final Map<MAssetImage, String> images = {
    MAssetImage.icon: "assets/images/icon.png",
    MAssetImage.banner: "assets/images/banner.jpg",
    MAssetImage.truck: "assets/images/truck.jpeg",
    MAssetImage.pfdIcon: "assets/images/pdf_icon.png",
    MAssetImage.emailIcon: "assets/images/email_icon.png",
    MAssetImage.scanIcon: "assets/images/scan_icon.png",
    MAssetImage.phoneIcon: "assets/images/phone_icon.png",
    MAssetImage.imageUploadIcon: "assets/images/image_upload_icon.png",
    MAssetImage.ctpatIcon: "assets/images/ctpat.png",
  };

  static String image(MAssetImage name) {
    return MAssets().images[name]!;
  }
}
