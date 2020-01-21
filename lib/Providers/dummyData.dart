class DummyData {
  List<DummyDataModel> _data = [
    DummyDataModel(
      leadingImage: 'https://firebasestorage.googleapis.com/v0/b/agrisensor-app.appspot.com/o/assets%2Ftomatoes.png?alt=media&token=6c6b457f-9b9c-4f99-bff0-de60c59781a7',
      title: 'Tomatoes',
      subTitle: 'Tomatoes can be planted using the following techniques',
      articleId: '1'
    ),
    DummyDataModel(
      leadingImage: 'https://firebasestorage.googleapis.com/v0/b/agrisensor-app.appspot.com/o/assets%2FCassava.jpg?alt=media&token=bf8879c0-3f99-4cd4-a1dc-c71acbdec54f',
      title: 'Cavasa',
      subTitle: 'Cavasa can be planted using the following techniques',
      articleId: '2'
    ),
    DummyDataModel(
      leadingImage: 'https://firebasestorage.googleapis.com/v0/b/agrisensor-app.appspot.com/o/assets%2Fonions.jpg?alt=media&token=40e0db41-f090-42dc-8a51-9a03326a6a89',
      title: 'Onion',
      subTitle: 'Onion can be planted using the following techniques',
      articleId: '3'
    ),
    DummyDataModel(
      leadingImage: 'https://firebasestorage.googleapis.com/v0/b/agrisensor-app.appspot.com/o/assets%2Fpiment1.jpg?alt=media&token=fc1f23ab-5993-49e0-b7d2-46fe3f55cc90',
      title: 'Chilli pepper',
      subTitle: 'Chilli pepper can be planted using the following techniques',
      articleId: '4'
    ),
    DummyDataModel(
      leadingImage: 'https://firebasestorage.googleapis.com/v0/b/agrisensor-app.appspot.com/o/assets%2Fpotato.jpg?alt=media&token=c3854567-fc3e-40f2-a40b-ae39e1a67f21',
      title: 'Potato',
      subTitle: 'Potato can be planted using the following techniques',
      articleId: '5'
    ),
  ];

  List<AvailableCropsForTest> _availableCrops = [
    AvailableCropsForTest(
      name: 'apple',
      icon: 'assets/SVGPics/apple.svg'
    ),
    AvailableCropsForTest(
      name: 'blueberry',
      icon: 'assets/SVGPics/blueberry.svg'
    ),
    AvailableCropsForTest(
      name: 'cherry',
      icon: 'assets/SVGPics/cherry.svg'
    ),
    AvailableCropsForTest(
      name: 'corn maize',
      icon: 'assets/SVGPics/corn.svg'
    ),
    AvailableCropsForTest(
      name: 'grape',
      icon: 'assets/SVGPics/grapes.svg'
    ),
    AvailableCropsForTest(
      name: 'orange',
      icon: 'assets/SVGPics/orange.svg'
    ),
    AvailableCropsForTest(
      name: 'peach',
      icon: 'assets/SVGPics/peach.svg'
    ),
    AvailableCropsForTest(
      name: 'pepper bell',
      icon: 'assets/SVGPics/peppersbell.svg',
    ),
    AvailableCropsForTest(
      name: 'potato',
      icon: 'assets/SVGPics/potato.svg'
    ),
    AvailableCropsForTest(
      name: 'raspberry',
      icon: 'assets/SVGPics/raspberry.svg'
    ),
    AvailableCropsForTest(
      name: 'soybean',
      icon: 'assets/SVGPics/soybean.svg'
    ),
    AvailableCropsForTest(
      name: 'squash powdery',
      icon: 'assets/SVGPics/squashpowdery.svg'
    ),
    AvailableCropsForTest(
      name: 'strawberry',
      icon: 'assets/SVGPics/strawberry.svg'
    ),
    AvailableCropsForTest(
      name: 'tomato',
      icon: 'assets/SVGPics/tomato.svg'
    ),
  ];

  List<AvailableCropsForTest> get availableCrops {
    return [..._availableCrops];
  }

  List<DummyDataModel> get dummyData {
    return [..._data];
  }
}

class DummyDataModel{
  final String title;
  final String subTitle;
  final String leadingImage;
  final String articleId;

  DummyDataModel({this.title, this.subTitle, this.leadingImage, this.articleId});
}

class AvailableCropsForTest{
  final String name;
  final String icon;

  AvailableCropsForTest({this.icon, this.name});
}