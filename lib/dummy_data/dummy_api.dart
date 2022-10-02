import 'dart:math';

class DummyApi {
  dynamic getuserdetail = {
    "success": true,
    "msg": "ok",
    "data": {
      "name": "Thor",
      "location": "Depok, Indonesia",
      "image":
          "https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHw%3D&w=1000&q=80",
      "email": "thor@gmail.com",
      "phone": "08123456789",
    }
  };

  //categori 1: sports, 2:entertainment, 3:workspace,
  dynamic getfacilities = {
    "success": true,
    "msg": "ok",
    "data": [
      {
        "id": 1,
        "name": "Swimming Evencio",
        "image":
            "https://www.bhg.com/thmb/297Jr2SVie5oHqkVlwtkR0t9foo=/1572x1244/filters:fill(auto,1)/home-pool-deck-ETQanX7FqE9Bc4s4W5s13r-4d7f47bf12e34d6aa5291c7ef93a7641.jpg",
        "location": "Evencio Apartment, Depok",
        "is_save": false,
        "rating": Random().nextInt(5),
        "category": 1,
        "is_booking": true,
        "booking_detail": {
          "book_id": 2,
          "book_status": 2,
          "ruangan": [
            "Premium",
          ],
          "date": "2022-09-29",
          "time": [
            "19.00-20.00",
            "20.00-21.00",
          ]
        },
      },
      {
        "id": 2,
        "name": "Gor Mantap",
        "image":
            "https://integralspor.com/uploads/blog/detail/161d68f72ea59771229.jpg",
        "location": "Depok",
        "is_save": false,
        "rating": Random().nextInt(5),
        "category": 1,
        "is_booking": true,
        "booking_detail": {
          "book_id": 2,
          "book_status": 1,
          "ruangan": [
            "A",
          ],
          "date": "2022-10-29",
          "time": [
            "20.00-24.00",
          ]
        },
      },
      {
        "id": 3,
        "name": "Karaoke Syariah",
        "image":
            "https://asset.kompas.com/crops/m9iAd1xtanbKhaHG9NqDF61y1d4=/0x24:414x300/750x500/data/photo/2022/07/12/62cd038c3730b.jpg",
        "location": "Wakanda",
        "is_save": true,
        "rating": Random().nextInt(5),
        "category": 2,
        "is_booking": true,
        "booking_detail": {
          "book_id": 2,
          "book_status": 2,
          "ruangan": [
            "VIP",
          ],
          "date": "2022-10-29",
          "time": [
            "20.00-24.00",
          ]
        },
      },
      {
        "id": 4,
        "name": "Selalu Fokus",
        "image":
            "https://www.incimages.com/uploaded_files/image/1920x1080/getty_517610514_353435.jpg",
        "location": "Evencio Apartment, Depok",
        "is_save": false,
        "rating": Random().nextInt(5),
        "category": 1,
        "is_booking": false,
        "booking_detail": {
          "book_id": 2,
          "book_status": 3,
          "ruangan": [
            "Silent",
          ],
          "date": "2022-10-29",
          "time": [
            "20.00-24.00",
          ]
        },
      },
    ]
  };

  dynamic getAllMyBooking = {
    "success": true,
    "msg": "ok",
    "data": [
      {
        "id": 1,
        "name": "Swimming Evencio",
        "image":
            "https://www.bhg.com/thmb/297Jr2SVie5oHqkVlwtkR0t9foo=/1572x1244/filters:fill(auto,1)/home-pool-deck-ETQanX7FqE9Bc4s4W5s13r-4d7f47bf12e34d6aa5291c7ef93a7641.jpg",
        "location": "Evencio Apartment, Depok",
        "is_save": false,
        "rating": Random().nextInt(5),
        "category": 1,
        "is_booking": true,
        "booking_detail": {
          "book_id": 2,
          "book_status": 2,
          "ruangan": [
            "Premium",
          ],
          "date": "2022-09-29",
          "time": [
            "19.00-20.00",
            "20.00-21.00",
          ]
        },
      },
      {
        "id": 3,
        "name": "Karaoke Syariah",
        "image":
            "https://asset.kompas.com/crops/m9iAd1xtanbKhaHG9NqDF61y1d4=/0x24:414x300/750x500/data/photo/2022/07/12/62cd038c3730b.jpg",
        "location": "Wakanda",
        "is_save": true,
        "rating": Random().nextInt(5),
        "category": 2,
        "is_booking": true,
        "booking_detail": {
          "book_id": 2,
          "book_status": 2,
          "ruangan": [
            "VIP",
          ],
          "date": "2022-10-29",
          "time": [
            "20.00-24.00",
          ]
        },
      },
      {
        "id": 2,
        "name": "Gor Mantap",
        "image":
            "https://integralspor.com/uploads/blog/detail/161d68f72ea59771229.jpg",
        "location": "Depok",
        "is_save": false,
        "rating": Random().nextInt(5),
        "category": 1,
        "is_booking": true,
        "booking_detail": {
          "book_id": 2,
          "book_status": 1,
          "ruangan": [
            "A",
          ],
          "date": "2022-10-29",
          "time": [
            "20.00-24.00",
          ]
        },
      },
    ]
  };

  dynamic getOnPayMyBook = {
    "success": true,
    "msg": "ok",
    "data": [
      {
        "id": 2,
        "name": "Gor Mantap",
        "image":
            "https://integralspor.com/uploads/blog/detail/161d68f72ea59771229.jpg",
        "location": "Depok",
        "is_save": false,
        "rating": Random().nextInt(5),
        "category": 1,
        "is_booking": true,
        "booking_detail": {
          "book_id": 2,
          "book_status": 1,
          "ruangan": [
            "A",
          ],
          "date": "2022-10-29",
          "time": [
            "20.00-24.00",
          ]
        },
      },
    ]
  };

  dynamic getHistoryMyBook = {
    "success": true,
    "msg": "ok",
    "data": [
      {
        "id": 4,
        "name": "Selalu Fokus",
        "image":
            "https://www.incimages.com/uploaded_files/image/1920x1080/getty_517610514_353435.jpg",
        "location": "Evencio Apartment, Depok",
        "is_save": false,
        "rating": Random().nextInt(5),
        "category": 1,
        "is_booking": false,
        "booking_detail": {
          "book_id": 2,
          "book_status": 3,
          "ruangan": [
            "Silent",
          ],
          "date": "2022-10-29",
          "time": [
            "20.00-24.00",
          ]
        },
      },
    ]
  };

  dynamic getOnBookingMyBook = {
    "success": true,
    "msg": "ok",
    "data": [
      {
        "id": 1,
        "name": "Swimming Evencio",
        "image":
            "https://www.bhg.com/thmb/297Jr2SVie5oHqkVlwtkR0t9foo=/1572x1244/filters:fill(auto,1)/home-pool-deck-ETQanX7FqE9Bc4s4W5s13r-4d7f47bf12e34d6aa5291c7ef93a7641.jpg",
        "location": "Evencio Apartment, Depok",
        "is_save": false,
        "rating": Random().nextInt(5),
        "category": 1,
        "is_booking": true,
        "booking_detail": {
          "book_id": 2,
          "book_status": 2,
          "ruangan": [
            "Premium",
          ],
          "date": "2022-09-29",
          "time": [
            "19.00-20.00",
            "20.00-21.00",
          ]
        },
      },
      {
        "id": 3,
        "name": "Karaoke Syariah",
        "image":
            "https://asset.kompas.com/crops/m9iAd1xtanbKhaHG9NqDF61y1d4=/0x24:414x300/750x500/data/photo/2022/07/12/62cd038c3730b.jpg",
        "location": "Wakanda",
        "is_save": true,
        "rating": Random().nextInt(5),
        "category": 2,
        "is_booking": true,
        "booking_detail": {
          "book_id": 2,
          "book_status": 2,
          "ruangan": [
            "VIP",
          ],
          "date": "2022-10-29",
          "time": [
            "20.00-24.00",
          ]
        },
      },
    ]
  };

  dynamic getfacilitiesByCartegory = {
    "success": true,
    "msg": "ok",
    "data": [
      {
        "id_category": 1,
        "category": "Sports",
        "facilities": [
          {
            "id": 1,
            "name": "Swimming Evencio",
            "image":
                "https://www.bhg.com/thmb/297Jr2SVie5oHqkVlwtkR0t9foo=/1572x1244/filters:fill(auto,1)/home-pool-deck-ETQanX7FqE9Bc4s4W5s13r-4d7f47bf12e34d6aa5291c7ef93a7641.jpg",
            "location": "Evencio Apartment, Depok",
            "is_save": false,
            "rating": Random().nextInt(5),
            "category": 1,
            "is_booking": true,
            "booking_detail": {
              "book_id": 2,
              "book_status": 2,
              "ruangan": [
                "Premium",
              ],
              "date": "2022-09-29",
              "time": [
                "19.00-20.00",
                "20.00-21.00",
              ]
            },
          },
          {
            "id": 2,
            "name": "Gor Mantap",
            "image":
                "https://integralspor.com/uploads/blog/detail/161d68f72ea59771229.jpg",
            "location": "Depok",
            "is_save": false,
            "rating": Random().nextInt(5),
            "category": 1,
            "is_booking": true,
            "booking_detail": {
              "book_id": 2,
              "book_status": 1,
              "ruangan": [
                "A",
              ],
              "date": "2022-10-29",
              "time": [
                "20.00-24.00",
              ]
            },
          },
        ],
      },
      {
        "id_category": 2,
        "category": "Entertainment",
        "facilities": [
          {
            "id": 3,
            "name": "Karaoke Syariah",
            "image":
                "https://asset.kompas.com/crops/m9iAd1xtanbKhaHG9NqDF61y1d4=/0x24:414x300/750x500/data/photo/2022/07/12/62cd038c3730b.jpg",
            "location": "Wakanda",
            "is_save": true,
            "rating": Random().nextInt(5),
            "category": 2,
            "is_booking": true,
            "booking_detail": {
              "book_id": 2,
              "book_status": 2,
              "ruangan": [
                "VIP",
              ],
              "date": "2022-10-29",
              "time": [
                "20.00-24.00",
              ]
            },
          },
        ],
      },
      {
        "id_category": 3,
        "category": "Workspace",
        "facilities": [
          {
            "id": 4,
            "name": "Selalu Fokus",
            "image":
                "https://www.incimages.com/uploaded_files/image/1920x1080/getty_517610514_353435.jpg",
            "location": "Evencio Apartment, Depok",
            "is_save": false,
            "rating": Random().nextInt(5),
            "category": 1,
            "is_booking": false,
            "booking_detail": {
              "book_id": 2,
              "book_status": 3,
              "ruangan": [
                "Silent",
              ],
              "date": "2022-10-29",
              "time": [
                "20.00-24.00",
              ]
            },
          },
        ],
      },
    ]
  };

  dynamic getMyFacilitiesByCategory = {
    "success": true,
    "msg": "ok",
    "data": [
      {
        "id_category": 0,
        "category": "All",
        "facilities": [
          {
            "id": 1,
            "name": "Swimming Evencio",
            "image":
                "https://www.bhg.com/thmb/297Jr2SVie5oHqkVlwtkR0t9foo=/1572x1244/filters:fill(auto,1)/home-pool-deck-ETQanX7FqE9Bc4s4W5s13r-4d7f47bf12e34d6aa5291c7ef93a7641.jpg",
            "location": "Evencio Apartment, Depok",
            "is_save": false,
            "rating": Random().nextInt(5),
            "category": 1,
            "is_booking": true,
            "booking_detail": {
              "book_id": 2,
              "book_status": 2,
              "ruangan": [
                "Premium",
              ],
              "date": "2022-09-29",
              "time": [
                "19.00-20.00",
                "20.00-21.00",
              ]
            },
          },
          {
            "id": 2,
            "name": "Gor Mantap",
            "image":
                "https://integralspor.com/uploads/blog/detail/161d68f72ea59771229.jpg",
            "location": "Depok",
            "is_save": false,
            "rating": Random().nextInt(5),
            "category": 1,
            "is_booking": true,
            "booking_detail": {
              "book_id": 2,
              "book_status": 1,
              "ruangan": [
                "A",
              ],
              "date": "2022-10-29",
              "time": [
                "20.00-24.00",
              ]
            },
          },
          {
            "id": 3,
            "name": "Karaoke Syariah",
            "image":
                "https://asset.kompas.com/crops/m9iAd1xtanbKhaHG9NqDF61y1d4=/0x24:414x300/750x500/data/photo/2022/07/12/62cd038c3730b.jpg",
            "location": "Wakanda",
            "is_save": true,
            "rating": Random().nextInt(5),
            "category": 2,
            "is_booking": true,
            "booking_detail": {
              "book_id": 2,
              "book_status": 2,
              "ruangan": [
                "VIP",
              ],
              "date": "2022-10-29",
              "time": [
                "20.00-24.00",
              ]
            },
          },
          {
            "id": 4,
            "name": "Selalu Fokus",
            "image":
                "https://www.incimages.com/uploaded_files/image/1920x1080/getty_517610514_353435.jpg",
            "location": "Evencio Apartment, Depok",
            "is_save": false,
            "rating": Random().nextInt(5),
            "category": 1,
            "is_booking": false,
            "booking_detail": {
              "book_id": 2,
              "book_status": 3,
              "ruangan": [
                "Silent",
              ],
              "date": "2022-10-29",
              "time": [
                "20.00-24.00",
              ]
            },
          },
        ],
      },
      {
        "id_category": 1,
        "category": "Sports",
        "facilities": [
          {
            "id": 1,
            "name": "Swimming Evencio",
            "image":
                "https://www.bhg.com/thmb/297Jr2SVie5oHqkVlwtkR0t9foo=/1572x1244/filters:fill(auto,1)/home-pool-deck-ETQanX7FqE9Bc4s4W5s13r-4d7f47bf12e34d6aa5291c7ef93a7641.jpg",
            "location": "Evencio Apartment, Depok",
            "is_save": false,
            "rating": Random().nextInt(5),
            "category": 1,
            "is_booking": true,
            "booking_detail": {
              "book_id": 2,
              "book_status": 2,
              "ruangan": [
                "Premium",
              ],
              "date": "2022-09-29",
              "time": [
                "19.00-20.00",
                "20.00-21.00",
              ]
            },
          },
          {
            "id": 2,
            "name": "Gor Mantap",
            "image":
                "https://integralspor.com/uploads/blog/detail/161d68f72ea59771229.jpg",
            "location": "Depok",
            "is_save": false,
            "rating": Random().nextInt(5),
            "category": 1,
            "is_booking": true,
            "booking_detail": {
              "book_id": 2,
              "book_status": 1,
              "ruangan": [
                "A",
              ],
              "date": "2022-10-29",
              "time": [
                "20.00-24.00",
              ]
            },
          },
        ],
      },
      {
        "id_category": 2,
        "category": "Entertainment",
        "facilities": [
          {
            "id": 3,
            "name": "Karaoke Syariah",
            "image":
                "https://asset.kompas.com/crops/m9iAd1xtanbKhaHG9NqDF61y1d4=/0x24:414x300/750x500/data/photo/2022/07/12/62cd038c3730b.jpg",
            "location": "Wakanda",
            "is_save": true,
            "rating": Random().nextInt(5),
            "category": 2,
            "is_booking": true,
            "booking_detail": {
              "book_id": 2,
              "book_status": 2,
              "ruangan": [
                "VIP",
              ],
              "date": "2022-10-29",
              "time": [
                "20.00-24.00",
              ]
            },
          },
        ],
      },
      {
        "id_category": 3,
        "category": "Workspace",
        "facilities": [
          {
            "id": 4,
            "name": "Selalu Fokus",
            "image":
                "https://www.incimages.com/uploaded_files/image/1920x1080/getty_517610514_353435.jpg",
            "location": "Evencio Apartment, Depok",
            "is_save": false,
            "rating": Random().nextInt(5),
            "category": 1,
            "is_booking": false,
            "booking_detail": {
              "book_id": 2,
              "book_status": 3,
              "ruangan": [
                "Silent",
              ],
              "date": "2022-10-29",
              "time": [
                "20.00-24.00",
              ]
            },
          },
        ],
      },
    ]
  };
}
