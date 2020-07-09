<!-- Features -->
<!-- Fixes -->
<!-- Chore & Maintenance -->
<!-- Performance -->

# CHANGELOG

## 0.12.2-alpha

### Chore & Maintenance

- Add tests for `Designs::AfterCreateService` [(#115)](https://github.com/rokumatsumoto/boyutluseyler/pull/115)
- Add files referenced in `README.md` [(#116)](https://github.com/rokumatsumoto/boyutluseyler/pull/116)
- Reduce the file size of images referenced in `README.md` file [(#117)](https://github.com/rokumatsumoto/boyutluseyler/pull/117)
- Update README.md [(#118)](https://github.com/rokumatsumoto/boyutluseyler/pull/118)

## 0.12.1-alpha

### Fixes

- A design that has never been downloaded before was giving an error if the blueprint files were updated [(#109)](https://github.com/rokumatsumoto/boyutluseyler/pull/109)
- Fix some bugs found while refactoring (I didn't note them, my bad)

### Chore & Maintenance

- Improve code coverage for Active Record models [(#109)](https://github.com/rokumatsumoto/boyutluseyler/pull/109)
- Improve code coverage for Service Objects [(#109)](https://github.com/rokumatsumoto/boyutluseyler/pull/109)
- Configure Reek for code smells [(#109)](https://github.com/rokumatsumoto/boyutluseyler/pull/109)
- Make the cops happy [(#109)](https://github.com/rokumatsumoto/boyutluseyler/pull/109)
- Remove unused files and code blocks [(#109)](https://github.com/rokumatsumoto/boyutluseyler/pull/109)
- Improve readability of code blocks [(#109)](https://github.com/rokumatsumoto/boyutluseyler/pull/109)
- Use modules for common functionality [(#109)](https://github.com/rokumatsumoto/boyutluseyler/pull/109)

### Performance

- Remove some methods executed unnecessarily [(#109)](https://github.com/rokumatsumoto/boyutluseyler/pull/109)

## 0.12.0-alpha

### Features

- Invalidate design list caches after destroying a design [(#91)](https://github.com/rokumatsumoto/boyutluseyler/pull/91)
- Invalidate category list cache after destroying a category [(#97)](https://github.com/rokumatsumoto/boyutluseyler/pull/97)
- Cache categories [(#88)](https://github.com/rokumatsumoto/boyutluseyler/pull/88)
- Cache design attributes [(#99)](https://github.com/rokumatsumoto/boyutluseyler/pull/99)

### Fixes

- Deployment failed for AWS EB [(#96)](https://github.com/rokumatsumoto/boyutluseyler/pull/96)
- Reload the environment when using pry-rails [(#104)](https://github.com/rokumatsumoto/boyutluseyler/pull/104)
- Show text for empty Design lists [(#101)](https://github.com/rokumatsumoto/boyutluseyler/pull/101)

### Chore & Maintenance

- Improve user experience design [(#88)](https://github.com/rokumatsumoto/boyutluseyler/pull/88)
- Update rack-mini-profiler gem [(#87)](https://github.com/rokumatsumoto/boyutluseyler/pull/87)
- Update Shoulda Matchers gem [(#102)](https://github.com/rokumatsumoto/boyutluseyler/pull/102)
- Add tests for Design model [(#104)](https://github.com/rokumatsumoto/boyutluseyler/pull/104)
- Update rubocop.yml configuration file [(#104)](https://github.com/rokumatsumoto/boyutluseyler/pull/104)

## 0.11.0-alpha

### Features

- Add policies for authorization [(#84)](https://github.com/rokumatsumoto/boyutluseyler/pull/84)
- Configure role management [(#84)](https://github.com/rokumatsumoto/boyutluseyler/pull/84)
- Add and configure `admin` role [(#84)](https://github.com/rokumatsumoto/boyutluseyler/pull/84)
- Protect admin pages with constraint [(#84)](https://github.com/rokumatsumoto/boyutluseyler/pull/84)
- Add sort by likes to popular and latest designs page [(#80)](https://github.com/rokumatsumoto/boyutluseyler/pull/80)

### Fixes

- Refactor design license partial view [(#84)](https://github.com/rokumatsumoto/boyutluseyler/pull/84)
- Code Climate test coverage not appearing [(#81)](https://github.com/rokumatsumoto/boyutluseyler/pull/81) [(#82)](https://github.com/rokumatsumoto/boyutluseyler/pull/82)
- Update AWS Lambda function name on the download process [(#80)](https://github.com/rokumatsumoto/boyutluseyler/pull/80)
- Remove experimental `parallel_tests` config [(#78)](https://github.com/rokumatsumoto/boyutluseyler/pull/78)
- Code Climate gives error on build [(#77)](https://github.com/rokumatsumoto/boyutluseyler/pull/77)

###  Chore & Maintenance

- Update Redis endpoint [(#84)](https://github.com/rokumatsumoto/boyutluseyler/pull/84)
- Update dev:prime rake task [(#84)](https://github.com/rokumatsumoto/boyutluseyler/pull/84)
- Update SimpleCov gem [(#78)](https://github.com/rokumatsumoto/boyutluseyler/pull/78)
- Update parallel_tests gem [(#78)](https://github.com/rokumatsumoto/boyutluseyler/pull/78)

## 0.10.0-alpha

### Features

- Implement sign in with Facebook and Google [(#75)](https://github.com/rokumatsumoto/boyutluseyler/pull/75)
- Add OAuth providers to sign up and sign-in page [(#75)](https://github.com/rokumatsumoto/boyutluseyler/pull/75)
- Add remember me option for OAuth providers [(#75)](https://github.com/rokumatsumoto/boyutluseyler/pull/75)
- Add connected accounts to user account page [(#75)](https://github.com/rokumatsumoto/boyutluseyler/pull/75)

### Fixes

- Resolve Omniauth CVE-2015-9284 [(#75)](https://github.com/rokumatsumoto/boyutluseyler/pull/75)

### Chore & Maintenance

- Refactor username validator method [(#75)](https://github.com/rokumatsumoto/boyutluseyler/pull/75)
- Add Omniauth error page [(#75)](https://github.com/rokumatsumoto/boyutluseyler/pull/75)

## 0.9.0-alpha

### Features

- Create avatar uploader component [(#71)](https://github.com/rokumatsumoto/boyutluseyler/pull/71)
- Add avatar uploader to the edit profile page [(#71)](https://github.com/rokumatsumoto/boyutluseyler/pull/71)
- Create initials avatar for users after sign up [(#71)](https://github.com/rokumatsumoto/boyutluseyler/pull/71) [serverless-initials-avatar](https://github.com/rokumatsumoto/serverless-initials-avatar)

### Chore & Maintenance

- Refactor direct upload process [(#71)](https://github.com/rokumatsumoto/boyutluseyler/pull/71)
- Remove seamless migration support on `Illustration` and `Blueprint` models for `image_url` column [(#71)](https://github.com/rokumatsumoto/boyutluseyler/pull/71)
- Configure Sidekiq for test environment [(#71)](https://github.com/rokumatsumoto/boyutluseyler/pull/71)

### Performance

- Stub AWS Lambda client responses on test environment [(#71)](https://github.com/rokumatsumoto/boyutluseyler/pull/71)
- Process background jobs inline when running acceptance tests [(#71)](https://github.com/rokumatsumoto/boyutluseyler/pull/71)

## 0.8.0-alpha

### Features

- Create like button component [(#59)](https://github.com/rokumatsumoto/boyutluseyler/pull/59)
- Add like button to the design page [(#59)](https://github.com/rokumatsumoto/boyutluseyler/pull/59)
- Create likes counter component [(#59)](https://github.com/rokumatsumoto/boyutluseyler/pull/59)
- Add likes counter to the design page [(#59)](https://github.com/rokumatsumoto/boyutluseyler/pull/59)

### Fixes

- Make backfill migrations reversible [(#59)](https://github.com/rokumatsumoto/boyutluseyler/pull/59)

### Chore & Maintenance

- Refactor page counters [(#59)](https://github.com/rokumatsumoto/boyutluseyler/pull/59)
- Refactor event names [(#59)](https://github.com/rokumatsumoto/boyutluseyler/pull/59)

### Performance

- Cache user events (`Liked design`, `Downloaded design`) [(#59)](https://github.com/rokumatsumoto/boyutluseyler/pull/59)
- Cache design likes count [(#59)](https://github.com/rokumatsumoto/boyutluseyler/pull/59)

## 0.7.0-alpha

**Add most downloaded section to the home page [(#50)](https://github.com/rokumatsumoto/boyutluseyler/pull/50)**

- Sort most downloaded `n` designs using calculated `hourly downloads count` (n = 8) [(#50)](https://github.com/rokumatsumoto/boyutluseyler/pull/50)
- Cache most downloaded `n` designs every hour [(#50)](https://github.com/rokumatsumoto/boyutluseyler/pull/50)
- Cache categories until a record updated on category list (create, update) [(#50)](https://github.com/rokumatsumoto/boyutluseyler/pull/50)
- Add Turkish letter support for username [(#50)](https://github.com/rokumatsumoto/boyutluseyler/pull/50)
- Create latest designs page [(#50)](https://github.com/rokumatsumoto/boyutluseyler/pull/50)
- Add sorting to latest designs page [(#50)](https://github.com/rokumatsumoto/boyutluseyler/pull/50)

**Refactor dynamic image resizer [(#52)](https://github.com/rokumatsumoto/boyutluseyler/pull/52)**

- Change `resize_default` function invoking mechanism from HTTP to s3 event-driven ([aws-node-dynamic-image-resizer/pull/#4](https://github.com/rokumatsumoto/aws-node-dynamic-image-resizer/pull/4)) [(#52)](https://github.com/rokumatsumoto/boyutluseyler/pull/52)
- The `resize_default` function runs image resizing process `asynchronously` for the `thumb`, `medium` and `large` sizes ([aws-node-dynamic-image-resizer/pull/#4](https://github.com/rokumatsumoto/aws-node-dynamic-image-resizer/pull/4)) [(#52)](https://github.com/rokumatsumoto/boyutluseyler/pull/52)
- Save processed objects into `destination_bucket` ([aws-node-dynamic-image-resizer/pull/#4](https://github.com/rokumatsumoto/aws-node-dynamic-image-resizer/pull/4)) [(#52)](https://github.com/rokumatsumoto/boyutluseyler/pull/52)
- Improve `resize` function performance ([aws-node-dynamic-image-resizer/pull/#5](https://github.com/rokumatsumoto/aws-node-dynamic-image-resizer/pull/5)) [(#52)](https://github.com/rokumatsumoto/boyutluseyler/pull/52)
- Refactor JS structure ([aws-node-dynamic-image-resizer/pull/#5](https://github.com/rokumatsumoto/aws-node-dynamic-image-resizer/pull/5)) [(#52)](https://github.com/rokumatsumoto/boyutluseyler/pull/52)

See all [changes](https://github.com/rokumatsumoto/aws-node-dynamic-image-resizer/blob/master/CHANGELOG.md) starting from version `2.0.0`

- Rename `image_url` variable to `thumb_url` on application-wide [(#52)](https://github.com/rokumatsumoto/boyutluseyler/pull/52)
- Configure new S3 bucket for processed objects [(#52)](https://github.com/rokumatsumoto/boyutluseyler/pull/52)

**Add popular designs section to the home page [(#55)](https://github.com/rokumatsumoto/boyutluseyler/pull/55)**

- Calculate popular designs using Exponential moving average [(#55)](https://github.com/rokumatsumoto/boyutluseyler/pull/55)(https://en.wikipedia.org/wiki/Moving_average#Exponential_moving_average)
- Sort popular `n` designs using `home popular at` variable (n = 12) [(#55)](https://github.com/rokumatsumoto/boyutluseyler/pull/55)
- Cache popular `n` designs every hour [(#55)](https://github.com/rokumatsumoto/boyutluseyler/pull/55)
- Create popular designs page [(#55)](https://github.com/rokumatsumoto/boyutluseyler/pull/55)
- Add sorting to the popular designs page [(#55)](https://github.com/rokumatsumoto/boyutluseyler/pull/55)

## 0.6.0-alpha

- Create page counters component
- Create downloads counter component
- Create views counter component
- Add tracker for viewed and downloaded designs
- Add counter cache to designs for downloads count JSONB association
- Add AhoyWorker for Ahoy async events (Downloaded design, Liked design, Saved design, etc.)

## 0.5.0-alpha

- Create a [download service](https://github.com/rokumatsumoto/aws-node-s3-zipper) on the AWS Lambda environment.
- Add AvailableDownloadBroadcastWorker background job for download process
- Add download channel using ActionCable for broadcasting available downloads
- Add download state machine for managing download status
- Create presigned URLs when download request
- Create download button component
- Add CleanupTmpCacheWorker background job (https://github.com/Shopify/bootsnap#usage)

## 0.4.0-alpha

- Change design system

## 0.3.0-alpha

- Dynamic image resizer

## 0.2.1-alpha

- Refactor ruby classes and modules
- Move to webdrivers gem in favor of deprecated chromedriver-helper
- Refactor username validator
- Refactor change password validator

## 0.2.0-alpha

- Allow everyone to see details of designs from within design page
- Change JSON response format to JSON:API for Connected Uploader component
- Refactor DraggableFileList and DraggableFileListItem component names

## 0.1.0-alpha

- Allow users to create and edit designs from within design page
