# Encoder Queueing for Cumulus Clips

A plugin to add encoding requests to a queue for processing when videos are uploaded to the Cumulus Clips video CMS.

Some reasoning, from Wes's original documentation:  

>  *This is a resource intensive process, and may take more often several minutes to less often several hours to complete. Please plan accordingly. Also note it is better to transcode a high resolution video into a lower resolution than it is to go from low to high. So when creating your videos, aim high for best results.
>  
>   Since each file upload triggers 3 ffmpeg jobs, and since it is possible to upload a carload of videos as fast as one can type the metadata, it has been demonstrated that the load average on jerboa can hit 75 or more. Thus, all jobs pass from cumulusclips to a primitive queuing system implemented in perl.*


# Installation

## Enqueueing the Queue

In order to use the perl-based queueing scripts, you'll need the [File::Queue](https://metacpan.org/pod/distribution/File-Queue/lib/File/Queue.pod) CPAN module, as well as Config::Tiny. iInstalling that may or may not look something like this:

```shell-script
$ sudo cpan File::Queue
$ sudo cpan Config::Tiny 
```

Then set the appropriate paths in config.config, and create a systemd unit for start-daemon.sh (which sources the last two paths in config.config).

If you are using sudo, you may need to disable requiretty appropriately(?):

```
Defaults:root !requiretty
```

## Adding a filter to the upload controller

This plugin requires changes to the core application code.  Luckily all we are doing is pre-pending the queueing command onto the encoder command. Thus, we can use a filter trigger to accomplish our goal. So, around line 235 in controllers/upload_info.php, we can replace this:

```php
// Begin transcoding
$commandOutput = $config->debugConversion ? CONVERSION_LOG : '/dev/null';
$command = 'nohup ' . Settings::get('php') . ' ' . DOC_ROOT . '/cc-core/system/encode.php --video="' . $videoId . '" >> ' .  $commandOutput . ' 2>&1 &';
exec($command);
```

with this:

```php
// Begin transcoding
$commandOutput = $config->debugConversion ? CONVERSION_LOG : '/dev/null';
$command = 'nohup ' . Settings::get('php') . ' ' . DOC_ROOT . '/cc-core/system/encode.php --video="' . $videoId . '" >> ' .  $commandOutput . ' 2>&1 &';
$command = Plugin::triggerFilter('upload_video.encoder.command', $command); 
exec($command);
```

