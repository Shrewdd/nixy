{pkgs}: let
  # ── krishna4a6av/Wallpapers/Rosepine ────────────────────────────────
  kBase = "https://raw.githubusercontent.com/krishna4a6av/Wallpapers/master/Rosepine";
  kFetch = name: sha256:
    pkgs.fetchurl {
      url = "${kBase}/${name}";
      inherit sha256;
    };

  anime-girl-flowers = kFetch "anime-girl-flowers.png" "sha256-t5jQluwZ0YLQtBrZwymIDEWRp9DkKFJ9AkYypBXJJNU=";
  blossom = kFetch "blossom.jpg" "sha256-IOZl3qxVhUlv/cQVYHGtyyoe7FXDZRcyMRWZuyFelzU=";
  clowscape = kFetch "clowscape.jpg" "sha256-gyOtrH5EYenBTAiP2HITAawlJ5yge/ZXmsgHAVeDhAs=";
  cyberdeath = kFetch "cyberdeath.png" "sha256-aEswEiwQra1db9wjazCqNB3yBWKqEM+JMbc8E1aL11k=";
  dominik-mayer = kFetch "dominik-mayer.jpg" "sha256-kceCfeBfOaZ5gj5ajlS86H20zo34nN4zyEhMmVeN4gk=";
  flower = kFetch "flower.jpg" "sha256-4tlxL5VrrRW3W9RVsIvkDpt3W3I9wXW+RwV83bETMN0=";
  girl-sword-glasses = kFetch "girl-with-sword-glasses.jpg" "sha256-C2PVBLcscOW/ExBvzgmElArbjW7/e5qXXIK0NEAlJu8=";
  joyboy = kFetch "joyboy.png" "sha256-k3SFZM9vHHzZYOBDjD3S5z433eXO3DnD7vTqAYXOu2c=";
  kaf = kFetch "kaf.jpeg" "sha256-iAHxmwprK93lfP2YGtpyPqjaTQlVCJdpJqKWQHyK3kE=";
  kenjaku = kFetch "kenjaku.png" "sha256-yHtwwawhYZMnQ2WAbo7t9Mp1fAjqS4MR1X+IS4Rc3cM=";
  lighthouse = kFetch "lighthouse.jpg" "sha256-43Fw90zcTr2RuT4CJkplmxfqLHL5s4cQW6dd7U7xiz4=";
  miami = kFetch "miami.jpg" "sha256-ly/MT9Ct+F/kU0Kann97NZXooZQfcicV8CbaqOBoY+Q=";
  miles = kFetch "miles.jpg" "sha256-EIOZDgK3ygamdyFh0P243Q3jbK3/5vLhv5tGZ6VCKnI=";
  pink-mecha = kFetch "pink-mecha.png" "sha256-UKSSmpFzl/n/zmVz7UA6g/V/Y+R/XqZehWV3mqY2zAc=";
  pnkMd = kFetch "pnkMd.jpg" "sha256-HKRNTMqx7LTBC0z2ezpQEaCgC2Dl/c9oaTMtjx+ehGQ=";
  puffy-stars = kFetch "puffy-stars.jpg" "sha256-UN/4cOjPJ/2AtbIBpJbs6iUeTT5Sh6AHKUHIIHVXFqw=";
  purple-road = kFetch "purple-road.png" "sha256-MmexNO3m6iXT2Ooz8SQo9VT5DKUbWjgIVjGhzPJ1a5s=";
  retrocmp = kFetch "retrocmp.jpg" "sha256-Msajm3fVpUL3zX9zUILxj7xOzTPbzT+ubAjvmoEpDAU=";
  sakurabranch = kFetch "sakurabranch.jpeg" "sha256-mJouFoiPYGRGzCkkASaRCRgJtgrHkX30ozBg/xmyEK4=";
  shougan2 = kFetch "shougan2.png" "sha256-/X64eC0yvoIq92ib084qpR5T/CDYl+EFMdFd/cjDRSk=";
  sixarms = kFetch "sixarms.jpg" "sha256-su+mq0PVvDvnQ36VNtm6B4GhCShUR+Hsy5hnDVYriuU=";
  starwars-xwing = kFetch "starwars-xwing.png" "sha256-wasviQRe2x9iFBYjBpgN5S1LLiHivgpOEHDIXVPiBIU=";
  telefpMd = kFetch "telefpMd.jpg" "sha256-PQVbI5bI8mEoAYwTnzcAMABTyeYWBmtOkgPqmFLps5Q=";
  windows-error = kFetch "windows-error.jpg" "sha256-Yr31nKWS1yLkxs6GxYQ6jHwKgJ+b9iqPcZbBY0suGLg=";

  krishnaLinks = [
    {
      name = "anime-girl-flowers.png";
      path = anime-girl-flowers;
    }
    {
      name = "blossom.jpg";
      path = blossom;
    }
    {
      name = "clowscape.jpg";
      path = clowscape;
    }
    {
      name = "cyberdeath.png";
      path = cyberdeath;
    }
    {
      name = "dominik-mayer.jpg";
      path = dominik-mayer;
    }
    {
      name = "flower.jpg";
      path = flower;
    }
    {
      name = "girl-with-sword-glasses.jpg";
      path = girl-sword-glasses;
    }
    {
      name = "joyboy.png";
      path = joyboy;
    }
    {
      name = "kaf.jpeg";
      path = kaf;
    }
    {
      name = "kenjaku.png";
      path = kenjaku;
    }
    {
      name = "lighthouse.jpg";
      path = lighthouse;
    }
    {
      name = "miami.jpg";
      path = miami;
    }
    {
      name = "miles.jpg";
      path = miles;
    }
    {
      name = "pink-mecha.png";
      path = pink-mecha;
    }
    {
      name = "pnkMd.jpg";
      path = pnkMd;
    }
    {
      name = "puffy-stars.jpg";
      path = puffy-stars;
    }
    {
      name = "purple-road.png";
      path = purple-road;
    }
    {
      name = "retrocmp.jpg";
      path = retrocmp;
    }
    {
      name = "sakurabranch.jpeg";
      path = sakurabranch;
    }
    {
      name = "shougan2.png";
      path = shougan2;
    }
    {
      name = "sixarms.jpg";
      path = sixarms;
    }
    {
      name = "starwars-xwing.png";
      path = starwars-xwing;
    }
    {
      name = "telefpMd.jpg";
      path = telefpMd;
    }
    {
      name = "windows-error.jpg";
      path = windows-error;
    }
  ];

  # ── fr0st-xyz/wallz/Rosé Pine ───────────────────────────────────────
  fBase = "https://raw.githubusercontent.com/fr0st-xyz/wallz/main/Ros%C3%A9%20Pine";
  fFetch = encodedName: storeName: sha256:
    pkgs.fetchurl {
      url = "${fBase}/${encodedName}";
      name = storeName;
      inherit sha256;
    };

  fr-01 = fFetch "01.%20Ros%C3%A9%20Pine.jpeg" "01-Rose-Pine.jpeg" "sha256-hnlr9v3RvSK296lrO2TbG09RKjB/9W0WQyA5dn2uC1w=";
  fr-02 = fFetch "02.%20Ros%C3%A9%20Pine.png" "02-Rose-Pine.png" "sha256-jnigukMtPmgdrBQdEW99KKioUVE+XKix2kiiRuSMXpM=";
  fr-03 = fFetch "03.%20Ros%C3%A9%20Pine.png" "03-Rose-Pine.png" "sha256-WFH63e3q6B38SfgFMzhFR4Vpb26hwUZq7ngIRCvlUBs=";
  fr-04 = fFetch "04.%20Ros%C3%A9%20Pine.jpg" "04-Rose-Pine.jpg" "sha256-+kieKFOWkUkjO/POkNyxdq1k2MLLy1eDoLmlj7He5Zc=";
  fr-05 = fFetch "05.%20Ros%C3%A9%20Pine.jpg" "05-Rose-Pine.jpg" "sha256-pienmklbIRK0aBhV/5oE9LQ4r19suIKB29GjkN9iCgs=";
  fr-06 = fFetch "06.%20Ros%C3%A9%20Pine.jpg" "06-Rose-Pine.jpg" "sha256-XNxv2CRnFtGD74V2wHjgiuwENUY/VoX7Vg0GahiL5Oc=";
  fr-07 = fFetch "07.%20Ros%C3%A9%20Pine.png" "07-Rose-Pine.png" "sha256-mjIQYBi887EQyTKbvSD0Gmoz/nFN4+AkhsudQbq6zQY=";
  fr-08 = fFetch "08.%20Ros%C3%A9%20Pine.jpg" "08-Rose-Pine.jpg" "sha256-le98mXFePv3Hh3XKylXpyaRQV5GLGyMQwbNYGcrFbMY=";
  fr-09 = fFetch "09.%20Ros%C3%A9%20Pine.jpg" "09-Rose-Pine.jpg" "sha256-ySPmoAPYsX90H19D5VULCXeZfnpks7JUFU3s/jITG5o=";
  fr-10 = fFetch "10.%20Ros%C3%A9%20Pine.jpg" "10-Rose-Pine.jpg" "sha256-6RXsjniHZzij/pTBlNK/TtlZZoXbYZvIaQEuV2KvCrQ=";
  fr-11 = fFetch "11.%20Ros%C3%A9%20Pine.jpg" "11-Rose-Pine.jpg" "sha256-ZKJ9OjnKufhc/6IkXwcv0SdYujDBM5kITgNiKWdzfkI=";
  fr-12 = fFetch "12.%20Ros%C3%A9%20Pine.png" "12-Rose-Pine.png" "sha256-eHKwZjs1NjM3OEH7wJeH40Gje6cvKNStswbAiR/4sKg=";
  fr-13 = fFetch "13.%20Ros%C3%A9%20Pine.png" "13-Rose-Pine.png" "sha256-6zVWw4S6tiF00vZKmUWtl/D0nYG2F9qk4e+e66/Jx4o=";
  fr-14 = fFetch "14.%20Ros%C3%A9%20Pine.png" "14-Rose-Pine.png" "sha256-Qmy+yCQEOnBQXVRXcRdNcTZzu9JP4NZmnBVW8NNZSUA=";
  fr-15 = fFetch "15.%20Ros%C3%A9%20Pine.jpg" "15-Rose-Pine.jpg" "sha256-aSgvKrVXBYyfbY/v2l9zccwRs6/D5VwCdqco4Oo7HEI=";
  fr-16 = fFetch "16.%20Ros%C3%A9%20Pine.png" "16-Rose-Pine.png" "sha256-FDSlo2XUz8XI5IHbTLQU8Q4CvZWSEnaqP55l6amdnZc=";
  fr-17 = fFetch "17.%20Ros%C3%A9%20Pine.jpg" "17-Rose-Pine.jpg" "sha256-zUWS0hFDCB6k32iXqPHzUCqWBcU82jCvaryBER88I/4=";
  fr-18 = fFetch "18.%20Ros%C3%A9%20Pine.jpeg" "18-Rose-Pine.jpeg" "sha256-H4OM5VRoRQF4/L8OhJYd7BTQsxy75CYiLQvECGef3sk=";
  fr-19 = fFetch "19.%20Ros%C3%A9%20Pine.jpeg" "19-Rose-Pine.jpeg" "sha256-8Zq7QzqlLswgilV6sOGBgcl+8L6XURYwxIh8FLz+1s0=";
  fr-20 = fFetch "20.%20Ros%C3%A9%20Pine.jpg" "20-Rose-Pine.jpg" "sha256-X9BdFzoVqy/rAwn8o7Hf9dKj3j1g9LtczQ1kUOBIa2E=";
  fr-21 = fFetch "21.%20Ros%C3%A9%20Pine.png" "21-Rose-Pine.png" "sha256-iajDpFBzyctQuQaVkrTUgbOYlGuqHi7vl3qPEp/ndDw=";

  fr0stLinks = [
    {
      name = "01. Rosé Pine.jpeg";
      path = fr-01;
    }
    {
      name = "02. Rosé Pine.png";
      path = fr-02;
    }
    {
      name = "03. Rosé Pine.png";
      path = fr-03;
    }
    {
      name = "04. Rosé Pine.jpg";
      path = fr-04;
    }
    {
      name = "05. Rosé Pine.jpg";
      path = fr-05;
    }
    {
      name = "06. Rosé Pine.jpg";
      path = fr-06;
    }
    {
      name = "07. Rosé Pine.png";
      path = fr-07;
    }
    {
      name = "08. Rosé Pine.jpg";
      path = fr-08;
    }
    {
      name = "09. Rosé Pine.jpg";
      path = fr-09;
    }
    {
      name = "10. Rosé Pine.jpg";
      path = fr-10;
    }
    {
      name = "11. Rosé Pine.jpg";
      path = fr-11;
    }
    {
      name = "12. Rosé Pine.png";
      path = fr-12;
    }
    {
      name = "13. Rosé Pine.png";
      path = fr-13;
    }
    {
      name = "14. Rosé Pine.png";
      path = fr-14;
    }
    {
      name = "15. Rosé Pine.jpg";
      path = fr-15;
    }
    {
      name = "16. Rosé Pine.png";
      path = fr-16;
    }
    {
      name = "17. Rosé Pine.jpg";
      path = fr-17;
    }
    {
      name = "18. Rosé Pine.jpeg";
      path = fr-18;
    }
    {
      name = "19. Rosé Pine.jpeg";
      path = fr-19;
    }
    {
      name = "20. Rosé Pine.jpg";
      path = fr-20;
    }
    {
      name = "21. Rosé Pine.png";
      path = fr-21;
    }
  ];

  allLinks = krishnaLinks ++ fr0stLinks;
in {
  inherit miami;
  links = allLinks;
  directory = pkgs.linkFarm "rosepine-wallpapers" allLinks;
}
