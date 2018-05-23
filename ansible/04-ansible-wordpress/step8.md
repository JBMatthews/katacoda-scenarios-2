## Handler and Configuration Testing

After running Ansible, your new config should rollout and nginx should be restarted.

1\. To test this, `cd` into your `/etc/hosts` file, and add `book.example.com`, such that the first line in your `hosts` file should resemble the following:

<pre>
127.0.0.01  localhost  book.example.com
</pre>

2\. Once you've added that, run the following commands to create the appropriate folder:

`cd ~  && \
mkdir -p /var/www/book.example.com`{{execute}}

3\. Then, run the following to formulate the test display:

`echo "<?php echo date('H:i:s'); " | tee /var/www/book.example.com/index.php`{{execute}}

4\. You should now verify that, the command was successful in copying to the file.

`cat /var/www/book.example.com/index.php`{{execute}}

5\. Now, before you move to the next step, check the status of the `php7.2-fpm` package. This is very important! Follow along closely:

`service php7.2-fpm status`{{execute}}

If it's running, move on to the next step, however if it is currently not running, start the service:

`service php7.2-fpm start`{{execute}}

6\. Finally, `curl` our `http://book.example.com` URL in your terminal. You should see the current time:

`curl http://book.example.com`{{execute}}

Now, that is pretty cool, huh?

7\. [Troubleshooting] If you are not receiving the current date and time, as depicted, please don't worry! It happens to the best of us. Here's the first two things to try:
> 1\. Restart nginx manually. This problem is specific to the Katacoda Lab environment, not Ansible. To proceed, to the following:

`service nginx restart`{{execute}}

> 2\. Go back to your `default` nginx folder and check for syntax errors. Also, check the indentation of code in your playbook.

You'll get it! Feel free to ask your instructor for help, if needed.
