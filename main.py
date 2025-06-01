import asyncio
import i18n
import os

from dotenv import load_dotenv
from health_ping import HealthPing
from telegram.ext import Application
dotenv_path = os.path.join(os.path.dirname(__file__), '.env')
load_dotenv(dotenv_path)
i18n.load_path.append('./assets/lang')
i18n.set('file_format', 'json')
i18n.set('filename_format', '{locale}.{format}')
i18n.set('locale', os.getenv("LANGUAGE"))
i18n.set('fallback', 'en-US')

from interactions.loader import load_interactions # noqa

if os.getenv("HEALTHCHECKS_ENDPOINT"):
    HealthPing(url=os.getenv("HEALTHCHECKS_ENDPOINT"),
               schedule="1 * * * *",
               retries=[60, 300, 720]).start()


def main():
    """
    Handles the initial launch of the program (entry point).
    """
    bot_api_url = os.getenv("BOT_API_URL")
    base_url = bot_api_url if bot_api_url else "https://api.telegram.org"

    token = os.getenv("BOT_TOKEN")
    application = Application \
      .builder() \
      .token(token) \
      .concurrent_updates(True) \
      .read_timeout(30) \
      .write_timeout(30) \
      .base_url(f"{base_url}/bot") \
      .build() # noqa

    if bot_api_url:
        application.bot.log_out()

    load_interactions(application)
    print("Simple Media Converter instance started!")

    application.run_polling()


if __name__ == '__main__':
    main()
