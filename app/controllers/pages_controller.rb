# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @illustrations = [
      {
        url: 'http://192.168.2.2:3000/images/sarge_bust_bw_1_large.jpg',
        imageUrl: 'http://192.168.2.2:3000/images/sarge_bust_bw_1_thumb.jpg',
        contentType: 'image/jpeg'
      },
      {
        url: 'http://192.168.2.2:3000/images/sarge_bust_01_large.jpg',
        imageUrl: 'http://192.168.2.2:3000/images/sarge_bust_01_thumb.jpg',
        contentType: 'image/jpeg'
      },
      {
        url: 'http://192.168.2.2:3000/images/sarge_bust_02_large.jpg',
        imageUrl: 'http://192.168.2.2:3000/images/sarge_bust_02_thumb.jpg',
        contentType: 'image/jpeg'
      },
      {
        url: 'http://192.168.2.2:3000/images/sarge_bust_03_large.jpg',
        imageUrl: 'http://192.168.2.2:3000/images/sarge_bust_03_thumb.jpg',
        contentType: 'image/jpeg'
      }
    ]

    @blueprints = [
      {
        url: 'http://localhost:3000/models/bowser_low_poly_flowalistik.stl',
        imageUrl: 'http://192.168.2.2:3000/images/sarge_bust_bw_1_thumb.jpg',
        contentType: 'application/vnd.ms-pki.stl'
      },
      {
        url: 'http://localhost:3000/models/bowser_low_poly_flowalistik.stl',
        imageUrl: '',
        contentType: 'application/vnd.ms-pki.stl'
      },
      {
        url: 'http://localhost:3000/images/sarge_bust_02_large.jpg',
        imageUrl: 'http://192.168.2.2:3000/images/sarge_bust_02_thumb.jpg',
        contentType: 'image/jpeg'
      },
      {
        url: 'http://localhost:3000/images/sarge_bust_03_large.jpg',
        imageUrl: 'http://192.168.2.2:3000/images/sarge_bust_03_thumb.jpg',
        contentType: 'image/jpeg'
      }
    ]

    # @blueprints2 = [
    #   {
    #     url: 'http://localhost:3000/models/bowser_low_poly_flowalistik.stl',
    #     imageUrl: 'http://192.168.2.2:3000/images/sarge_bust_bw_1_thumb.jpg',
    #     contentType: 'application/vnd.ms-pki.stl'
    #   },
    #   {
    #     url: 'http://localhost:3000/models/bowser_low_poly_flowalistik.stl',
    #     imageUrl: '',
    #     contentType: 'application/vnd.ms-pki.stl'
    #   },
    #   {
    #     url: 'http://localhost:3000/images/sarge_bust_02_large.jpg',
    #     imageUrl: 'http://192.168.2.2:3000/images/sarge_bust_02_thumb.jpg',
    #     contentType: 'image/jpeg'
    #   },
    #   {
    #     url: 'http://localhost:3000/images/sarge_bust_03_large.jpg',
    #     imageUrl: 'http://192.168.2.2:3000/images/sarge_bust_03_thumb.jpg',
    #     contentType: 'image/jpeg'
    #   }
    # ]
   end

  def test_stl_viewer; end

  def test_slider; end
end
